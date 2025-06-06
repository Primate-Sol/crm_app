require_relative 'input_sanitizer'
require 'date'

class TaskSanitizer
  def self.sanitize(attributes)
    {
      title: InputSanitizer.clean_string(attributes[:title]),
      description: InputSanitizer.clean_string(attributes[:description]),
      status: InputSanitizer.clean_string(attributes[:status]),
      due_date: sanitize_due_date(attributes[:due_date])
    }
  end

  def self.sanitize_due_date(raw_date)
    return nil unless raw_date
    return raw_date if raw_date.is_a?(Date)

    clean = InputSanitizer.clean_string(raw_date)
    begin
      Date.parse(clean).to_s
    rescue Date::Error
      nil
    end
  end
end
