# app/services/client_sanitizer.rb
require_relative '../lib/input_sanitizer'

class ClientSanitizer
  class << self
    def sanitize(attributes)
      {
        name: clean(attributes[:name]),
        email: normalize_email(attributes[:email]),
        phone: clean_optional(attributes[:phone]),
        notes: clean_optional(attributes[:notes])
      }
    end

    private

    def clean(value)
      InputSanitizer.clean_string(value)
    end

    def normalize_email(value)
      InputSanitizer.normalize_email(value)
    end

    def clean_optional(value)
      value ? clean(value) : nil
    end
  end
end
