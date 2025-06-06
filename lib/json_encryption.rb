# lib/json_encryption.rb
require 'active_support/message_encryptor'
require 'active_support/key_generator'
require 'json'

module JsonEncryption
  # Derive a secure 256-bit key using a dedicated encryption key base and a salt
  key_base = Rails.application.credentials.encryption_key_base
  raise "Missing encryption_key_base in credentials" unless key_base.present?

  KEY = ActiveSupport::KeyGenerator.new(key_base).generate_key('json encryption salt', 32)
  ENCRYPTOR = ActiveSupport::MessageEncryptor.new(KEY)

  # Encrypts a Ruby object (hash, string, etc.) to a secure encrypted string
  def self.encrypt(data)
    json_data = data.is_a?(String) ? data : data.to_json
    ENCRYPTOR.encrypt_and_sign(json_data)
  end

  # Decrypts a secure string and returns either a parsed JSON object or raw string
  def self.decrypt(encrypted_data)
    decrypted = ENCRYPTOR.decrypt_and_verify(encrypted_data)
    JSON.parse(decrypted)
  rescue JSON::ParserError
    # In case it's a raw encrypted string (e.g., password_digest), return decrypted string
    decrypted
  rescue ActiveSupport::MessageEncryptor::InvalidMessage => e
    Rails.logger.error("JSON decryption failed: #{e.message}. Data size: #{encrypted_data&.bytesize || 0} bytes")
    nil
  end
end
