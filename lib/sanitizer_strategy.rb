# frozen_string_literal: true

module SanitizerStrategy
  # Clean and sanitize the input string
  # @param input [String] The string to be sanitized
  # @return [String] The sanitized string
  def clean_string(input)
    raise ArgumentError, "Input must be a String, got #{input.class}" unless input.is_a?(String)
    raise NotImplementedError, 'Implement clean_string in your strategy'
  end

  # Validate if the input meets specific criteria
  # @param input [String] The input to validate
  # @return [Boolean]
  def valid_input?(input)
    raise ArgumentError, "Input must be a String, got #{input.class}" unless input.is_a?(String)
    raise NotImplementedError, 'Implement valid_input? in your strategy'
  end
end
