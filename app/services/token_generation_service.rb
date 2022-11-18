# frozen_string_literal: true

# This class in consume by the 'User' model in order to generate a random token on user creation
# Main class for generate tokens
class TokenGenerationService
  def self.generate
    SecureRandom.hex  # To generate a random string
  end
end
