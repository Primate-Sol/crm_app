# app/services/client_sanitizer.rb
require_relative '../../lib/input_sanitizer'

class ClientSanitizer
  def self.sanitize(attributes)
    sanitizer = new
    {
      name: sanitizer.clean(attributes[:name]),
      email: sanitizer.clean_email(attributes[:email]),
      phone: sanitizer.clean_optional(attributes[:phone]),
      notes: sanitizer.clean_optional(attributes[:notes])
    }
  end

  def clean(value)
    InputSanitizer.clean_string(value)
  rescue StandardError => e
    raise StandardError, "Failed to sanitize value #{value.inspect}: #{e.message}"
  end

  def clean_email(email)
    InputSanitizer.normalize_email(email)
  rescue StandardError => e
    raise StandardError, "Failed to sanitize email #{email.inspect}: #{e.message}"
  end

  def clean_optional(value)
    value ? clean(value) : nil
  end
end
