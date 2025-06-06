require_relative '../lib/input_sanitizer'

class ClientSanitizer
  def self.sanitize(attributes)
    {
      name: InputSanitizer.clean_string(attributes[:name]),
      email: InputSanitizer.normalize_email(attributes[:email]),
      phone: attributes[:phone] ? InputSanitizer.clean_string(attributes[:phone]) : nil,
      notes: attributes[:notes] ? InputSanitizer.clean_string(attributes[:notes]) : nil
    }
  end
end
