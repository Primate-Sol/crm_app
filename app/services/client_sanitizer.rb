# app/services/client_sanitizer.rb
require_relative '../lib/input_sanitizer'

class ClientSanitizer
  def self.sanitize(attributes)
    sanitizer = InputSanitizer
    {
      name: clean(attributes[:name]),
      email: normalize_email(attributes[:email]),
      phone: sanitize_optional(attributes[:phone]),
      notes: sanitize_optional(attributes[:notes])
    }
  end

  def self.clean(value)
    InputSanitizer.clean_string(value)
  rescue StandardError => e
    raise StandardError, "Failed to sanitize input: #{e.message}"
  end

  def self.normalize_email(email)
    InputSanitizer.normalize_email(email)
  rescue StandardError => e
    raise StandardError, "Failed to normalize email: #{e.message}"
  end

  def self.sanitize_optional(value)
    value ? clean(value) : nil
  end
end
