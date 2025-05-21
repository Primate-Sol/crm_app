require 'json'
require 'bcrypt'
require 'securerandom'

class UserStorage
  def initialize(file_path)
    @file_path = file_path
  end

  def all
    JSON.parse(File.read(@file_path))
  end

  def find_by_email(email)
    all.find { |u| u["email"] == email }
  end

  def create(email, password)
    users = all
    hashed_pw = BCrypt::Password.create(password)
    users << { "id" => SecureRandom.uuid, "email" => email, "password_digest" => hashed_pw }
    File.write(@file_path, JSON.pretty_generate(users))
  end

  def authenticate(email, password)
    user = find_by_email(email)
    return nil unless user
    BCrypt::Password.new(user["password_digest"]) == password ? user : nil
  end
end
