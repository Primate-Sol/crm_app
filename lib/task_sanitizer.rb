# lib/task_sanitizer.rb
# frozen_string_literal: true

require_relative './input_sanitizer'
require_relative './sanitizer_strategy'

class TaskSanitizer
  include SanitizerStrategy

  STRING_ATTRS = [:title, :description, :status].freeze

  def initialize(sanitizer_strategy = InputSanitizer)
    unless sanitizer_strategy.singleton_class.included_modules.include?(SanitizerStrategy)
      raise ArgumentError, 'Sanitizer must implement SanitizerStrategy interface'
    end

    @sanitizer = sanitizer_strategy
  end

  def sanitize(attributes)
    sanitized_strings = batch_clean_strings(attributes.slice(*STRING_ATTRS))
    sanitized_strings.merge(due_date: sanitize_due_date(attributes[:due_date]))
  end

  def batch_clean_strings(task_attributes)
    task_attributes.transform_values { |v| @sanitizer.clean_string(v) }
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
