require 'securerandom'
require 'date'
require_relative '../../lib/task_sanitizer'

class Task
  include ActiveModel::Model
  attr_accessor :title, :description, :status, :due_date
  attr_reader :id

  # Task statuses:
  # - pending: Task is created but not started
  # - in_progress: Task is currently being worked on
  # - completed: Task is finished
  VALID_STATUSES = %w[pending in_progress completed]

  validates :title, presence: true
  validates :status, inclusion: { in: VALID_STATUSES }
  validates :due_date, format: { with: /\A\d{4}-\d{2}-\d{2}\z/, message: 'must be in ISO format (YYYY-MM-DD)' }, allow_nil: true

  def initialize(attributes = {})
    sanitized = TaskSanitizer.sanitize(attributes)
    super(sanitized)
    @id ||= SecureRandom.uuid
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
end
