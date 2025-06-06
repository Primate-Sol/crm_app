require 'bcrypt'
require 'securerandom'
require_relative '../../lib/json_encryption'
require 'active_support/core_ext/string/strip'
require 'action_view/helpers/sanitize_helper'

class User
  include ActiveModel::Model
  include ActionView::Helpers::SanitizeHelper

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
    sanitize_fields
  end

  def password=(plain_password)
    @password = plain_password
    @password_needs_hashing = true
  end

  def ensure_password_hashed
    if @password_needs_hashing && @password.present?
      @password_digest = BCrypt::Password.create(@password)
      @password_needs_hashing = false
    end
  end

  def as_json(*)
    ensure_password_hashed
    {
      id: id,
      name: name,
      email: email,
      password_digest: JsonEncryption.encrypt(@password_digest.to_s)
    }
  end

  def self.from_json(file_path)
    data = JsonFileStore.read(file_path)
    data.map do |user_data|
      decrypted_password = JsonEncryption.decrypt(user_data["password_digest"])
      user = new(
        name: user_data["name"],
        email: user_data["email"],
        password: decrypted_password
      )
      user.instance_variable_set(:@id, user_data["id"])
      user.ensure_password_hashed
      user
    end
  end

  def self.save_all(users, file_path)
    users.each(&:ensure_password_hashed)
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

  def sanitize_fields
    self.name = strip_tags(name.to_s).strip
    self.email = strip_tags(email.to_s).downcase.strip
  end
end
