require 'active_support/message_encryptor'
require 'active_support/key_generator'

module JsonEncryption
  # Derive a secure 256-bit key using a dedicated encryption key base and a salt
  key_base = Rails.application.credentials.encryption_key_base
  raise "Missing encryption_key_base in credentials" unless key_base.present?

  KEY = ActiveSupport::KeyGenerator.new(key_base).generate_key('json encryption salt', 32)
  ENCRYPTOR = ActiveSupport::MessageEncryptor.new(KEY)

  def self.encrypt(data)
    ENCRYPTOR.encrypt_and_sign(data.to_json)
  end

  def self.decrypt(encrypted_data)
    JSON.parse(ENCRYPTOR.decrypt_and_verify(encrypted_data))
  rescue ActiveSupport::MessageEncryptor::InvalidMessage => e
    Rails.logger.error("JSON decryption failed: #{e.message}. Data size: #{encrypted_data.bytesize} bytes")
    nil
  end
end
