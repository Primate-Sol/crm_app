class ClientSanitizer
  def self.sanitize(attributes)
    @sanitizer = InputSanitizer
    {
      name: @sanitizer.clean_string(attributes[:name]),
      email: @sanitizer.normalize_email(attributes[:email]),
      phone: sanitize_optional(attributes[:phone]),
      notes: sanitize_optional(attributes[:notes])
    }
  end

  def self.sanitize_optional(value)
    value ? @sanitizer.clean_string(value) : nil
  end
end
