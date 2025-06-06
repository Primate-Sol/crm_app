require 'bcrypt'
require 'securerandom'
require_relative '../../lib/json_encryption'

class User
  include ActiveModel::Model
  attr_accessor :name, :email, :password
  attr_reader :id

  EMAIL_FORMAT = /\A[^@\s]+@[^@\s]+\z/o

  PASSWORD_RULES = [
    { regex: /.{8,}/, message: "must be at least 8 characters" },
    { regex: /[a-z]/, message: "must include at least one lowercase letter" },
    { regex: /[A-Z]/, message: "must include at least one uppercase letter" },
    { regex: /\d/, message: "must include at least one number" },
    { regex: /[^A-Za-z0-9]/, message: "must include at least one special character" }
  ]

  validates :name, presence: true
  validates :email, presence: true, format: { with: EMAIL_FORMAT }
  validate :validate_password

  def initialize(attributes = {})
    super
    @id ||= SecureRandom.uuid
  end

  def password=(plain_password)
    @password = plain_password
    @password_digest = BCrypt::Password.create(plain_password)
  end

  def as_json(*)
    {
      id: id,
      name: name,
      email: email,
      password_digest: JsonEncryption.encrypt(@password_digest.to_s)
    }
  end

  def self.from_json(file_path)
    # Example: Load users from JSON file using JsonFileStore or similar
    data = JsonFileStore.read(file_path)
    data.map do |user_data|
      decrypted_password = JsonEncryption.decrypt(user_data["password_digest"])
      user = new(
        name: user_data["name"],
        email: user_data["email"],
        password: decrypted_password
      )
      user.instance_variable_set(:@id, user_data["id"])
      user
    end
  end

  def self.save_all(users, file_path)
    data = users.map(&:as_json)
    JsonFileStore.write(file_path, data)
  end

  private

  def validate_password
    if password.blank?
      errors.add(:password, "can't be blank")
    else
      PASSWORD_RULES.each do |rule|
        errors.add(:password, rule[:message]) unless password.match?(rule[:regex])
      end
    end
  end
end
