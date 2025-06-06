require 'action_view'
require 'active_support/core_ext/string/inflections'

module InputSanitizer
  extend ActionView::Helpers::SanitizeHelper

  def self.clean_string(str)
    strip_tags(str.to_s).strip
  end

  def self.normalize_email(email)
    clean_string(email).downcase
  end
end
