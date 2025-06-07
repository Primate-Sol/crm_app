# frozen_string_literal: true

module SanitizerStrategy
  # Clean and sanitize the input string
  # @param input [String] The string to be sanitized
  # @return [String] The sanitized string
  def clean_string(input)
    validate_string_type!(input)
    raise NotImplementedError, 'Implement clean_string in your strategy'
  end

  # Validate if the input meets specific criteria
  # @param input [String] The input to validate
  # @return [Boolean]
  def valid_input?(input)
    validate_string_type!(input)
    raise NotImplementedError, 'Implement valid_input? in your strategy'
  end

  private

  # Ensures the input is a String
  # @param input [Object] The input to check
  # @raise [ArgumentError] if the input is not a String
  def validate_string_type!(input)
    raise ArgumentError, "Input must be a String, got #{input.class}" unless input.is_a?(String)
  end
end
