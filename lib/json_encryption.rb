require 'active_support'
require 'active_support/core_ext'
require 'active_support/message_encryptor'

module JsonEncryption
  KEY = Rails.application.credentials.secret_key_base.byteslice(0..31)
  CIPHER = 'aes-256-gcm'

  def self.encrypt(data)
    encryptor = ActiveSupport::MessageEncryptor.new(KEY, cipher: CIPHER)
    encryptor.encrypt_and_sign(data)
  end

  def self.decrypt(encrypted_data)
    encryptor = ActiveSupport::MessageEncryptor.new(KEY, cipher: CIPHER)
    encryptor.decrypt_and_verify(encrypted_data)
  end
end
