require 'securerandom'
require_relative '../../lib/json_encryption'
require_relative '../../lib/input_sanitizer'

class Client
  include ActiveModel::Model
  attr_accessor :name, :email, :phone, :notes
  attr_reader :id

  EMAIL_FORMAT = /\A[^@\s]+@[^@\s]+\z/o

  validates :name, presence: true
  validates :email, presence: true, format: { with: EMAIL_FORMAT }

  def initialize(attributes = {})
    super
    @id ||= SecureRandom.uuid
    sanitize_inputs
  end

  def as_json(*)
    {
      id: id,
      name: name,
      email: email,
      phone: phone,
      notes: notes
    }
  end

  def self.from_json(file_path)
    data = JsonFileStore.read(file_path)
    data.map do |client_data|
      client = new(
        name: client_data["name"],
        email: client_data["email"],
        phone: client_data["phone"],
        notes: client_data["notes"]
      )
      client.instance_variable_set(:@id, client_data["id"])
      client
    end
  end

  def self.save_all(clients, file_path)
    data = clients.map(&:as_json)
    JsonFileStore.write(file_path, data)
  end

  private

  def sanitize_inputs
    self.name = InputSanitizer.clean_string(name)
    self.email = InputSanitizer.normalize_email(email)
    self.phone = InputSanitizer.clean_string(phone) if phone
    self.notes = InputSanitizer.clean_string(notes) if notes
  end
end
