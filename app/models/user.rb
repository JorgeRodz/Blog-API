# frozen_string_literal: true

# Main 'user' model class
class User < ApplicationRecord
  has_many :posts

  validates :email, presence: true
  validates :name, presence: true
  validates :auth_token, presence: true

  # Basically after create a new user
  after_initialize :generate_auth_token

  def generate_auth_token
    # if !auth_token.present?
    unless auth_token.present?
      self.auth_token = TokenGenerationService.generate # call the generate token service on app/services/token_generation_service.rb
    end
  end
end
