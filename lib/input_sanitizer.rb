require 'action_view'
require_relative './sanitizer_strategy'

module InputSanitizer
  extend self
  include SanitizerStrategy
  include ActionView::Helpers::SanitizeHelper

  # Removes HTML tags and trims whitespace
  def clean_string(str)
    strip_tags(str.to_s).strip
  end

  # Normalizes an email by stripping tags, trimming, and downcasing
  def normalize_email(email)
    clean_string(email).downcase
  end
end
