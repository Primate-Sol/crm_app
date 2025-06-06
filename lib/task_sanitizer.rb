# lib/task_sanitizer.rb
class TaskSanitizer
  def initialize(sanitizer_strategy = InputSanitizer)
    @sanitizer = sanitizer_strategy
  end

  def sanitize(attributes)
    string_attrs = [:title, :description, :status]
    sanitized_strings = batch_clean_strings(attributes.slice(*string_attrs))

    sanitized_strings.merge(due_date: sanitize_due_date(attributes[:due_date]))
  end

  private

  def batch_clean_strings(attrs)
    attrs.transform_values { |v| @sanitizer.clean_string(v) }
  end

  def sanitize_due_date(raw_date)
    return nil unless raw_date
    return raw_date if raw_date.is_a?(Date)

    clean = @sanitizer.clean_string(raw_date)
    Date.parse(clean)
  rescue Date::Error
    nil
  end
end
