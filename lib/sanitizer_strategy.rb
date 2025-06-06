# lib/sanitizer_strategy.rb
module SanitizerStrategy
  # Clean and sanitize the input string
  # @param input [String] The string to be sanitized
  # @return [String] The sanitized string
  def clean_string(input)
    raise NotImplementedError, 'Implement clean_string in your strategy'
  end
end
