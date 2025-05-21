require 'bcrypt'
require 'json'
require 'securerandom'

class User
  attr_accessor :id, :name, :email, :password_digest

def initialize(attrs = {})
  @id = attrs[:id] || attrs["id"] || SecureRandom.uuid
  @name = attrs[:name] || attrs["name"]
  @email = attrs[:email] || attrs["email"]
  @password_digest = attrs[:password_digest] || attrs["password_digest"]
end


  def self.from_json(file_path)
    return [] unless File.exist?(file_path)
    JSON.parse(File.read(file_path)).map { |data| User.new(data) }
  end

  def self.save_all(users, file_path)
    File.write(file_path, JSON.pretty_generate(users.map(&:to_h)))
  end

  def to_h
    {
      id: id,
      name: name,
      email: email,
      password_digest: password_digest
    }
  end

  def password=(new_password)
    @password_digest = BCrypt::Password.create(new_password)
  end

  def authenticate(input_password)
    return false unless password_digest
    BCrypt::Password.new(password_digest) == input_password
  rescue BCrypt::Errors::InvalidHash
    false
  end

  # Helper to find a user by ID
  def self.find_by_id(user_id)
    users = from_json(Rails.root.join("data", "users.json"))
    users.find { |u| u.id == user_id }
  end
end

