# lib/input_sanitizer.rb
require 'action_view'
require_relative './sanitizer_strategy'

module InputSanitizer
  extend self
  include SanitizerStrategy
  include ActionView::Helpers::SanitizeHelper

  def clean_string(str)
    strip_tags(str.to_s).strip
  end

  def normalize_email(email)
    clean_string(email).downcase
  end
end
