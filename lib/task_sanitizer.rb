require_relative './input_sanitizer'

# Optional: Define an interface module for clarity and safety
module SanitizerStrategy
  def clean_string(input)
    raise NotImplementedError
  end

  def normalize_email(input)
    raise NotImplementedError
  end
end

class TaskSanitizer
  STRING_ATTRS = [:title, :description, :status].freeze

  def initialize(sanitizer_strategy = InputSanitizer)
    unless sanitizer_strategy.respond_to?(:clean_string)
      raise ArgumentError, "Sanitizer must implement :clean_string"
    end

    @sanitizer = sanitizer_strategy
  end

  def sanitize(attributes)
    sanitized_strings = batch_clean_strings(attributes.slice(*STRING_ATTRS))
    sanitized_strings.merge(due_date: sanitize_due_date(attributes[:due_date]))
  end

  private

  def batch_clean_strings(attr_hash)
    attr_hash.transform_values { |v| @sanitizer.clean_string(v) }
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
