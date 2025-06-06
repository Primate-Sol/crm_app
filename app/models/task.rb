require 'securerandom'
require_relative '../../lib/json_encryption'
require_relative '../../lib/input_sanitizer'

class Task
  include ActiveModel::Model
  attr_accessor :title, :description, :status, :due_date
  attr_reader :id

  VALID_STATUSES = %w[pending in_progress completed]

  validates :title, presence: true
  validates :status, inclusion: { in: VALID_STATUSES }, allow_nil: true

  def initialize(attributes = {})
    super
    @id ||= SecureRandom.uuid
    sanitize_inputs
  end

  def as_json(*)
    {
      id: id,
      title: title,
      description: description,
      status: status,
      due_date: due_date
    }
  end

  def self.from_json(file_path)
    data = JsonFileStore.read(file_path)
    data.map do |task_data|
      task = new(
        title: task_data["title"],
        description: task_data["description"],
        status: task_data["status"],
        due_date: task_data["due_date"]
      )
      task.instance_variable_set(:@id, task_data["id"])
      task
    end
  end

  def self.save_all(tasks, file_path)
    data = tasks.map(&:as_json)
    JsonFileStore.write(file_path, data)
  end

  private

  def sanitize_inputs
    self.title = InputSanitizer.clean_string(title)
    self.description = InputSanitizer.clean_string(description) if description
    self.status = status if VALID_STATUSES.include?(status)
    # Assuming due_date is a date or string in ISO format, sanitize if string:
    if due_date.is_a?(String)
      self.due_date = InputSanitizer.clean_string(due_date)
    end
  end
end
