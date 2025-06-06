require_relative '../lib/input_sanitizer'

class ClientSanitizer
  def self.sanitize(attributes)
    sanitizer = InputSanitizer
    {
      name: sanitizer.clean_string(attributes[:name]),
      email: sanitizer.normalize_email(attributes[:email]),
      phone: sanitize_optional(attributes[:phone], sanitizer),
      notes: sanitize_optional(attributes[:notes], sanitizer)
    }
  end

  def self.sanitize_optional(value, sanitizer)
    value ? sanitizer.clean_string(value) : nil
  end
end
