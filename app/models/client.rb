require 'securerandom'
require_relative '../../lib/json_encryption'
require_relative '../../lib/input_sanitizer'
require_relative '../../services/client_sanitizer'

class Client
  include ActiveModel::Model
  attr_accessor :name, :email, :phone, :notes
  attr_reader :id

  EMAIL_FORMAT = /\A[a-zA-Z0-9.!#$%&'*+\/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?)*\z/o

  validates :name, presence: true
  validates :email, presence: true, format: { with: EMAIL_FORMAT }

  def initialize(attributes = {})
    sanitized = ClientSanitizer.sanitize(attributes)
    super(sanitized)
    @id ||= SecureRandom.uuid
  end

  def as_json(*)
    {
      id: id,
      name: name,
      email: email,
      phone: JsonEncryption.encrypt(phone),
      notes: JsonEncryption.encrypt(notes)
    }
  end

  def self.from_json(file_path)
    data = JsonFileStore.read(file_path)
    data.map do |client_data|
      client = new(
        name: client_data["name"],
        email: client_data["email"],
        phone: JsonEncryption.decrypt(client_data["phone"]),
        notes: JsonEncryption.decrypt(client_data["notes"])
      )
      client.instance_variable_set(:@id, client_data["id"])
      client
    end
  end

  def self.save_all(clients, file_path)
    data = clients.map(&:as_json)
    JsonFileStore.write(file_path, data)
  end
end
