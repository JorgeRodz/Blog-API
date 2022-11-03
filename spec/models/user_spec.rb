# frozen_string_literal: true

require 'rails_helper'

RSpec.describe User, type: :model do
  describe 'validations and relations - ' do
    it 'validate presence of required files' do
      should validate_presence_of(:email)
      should validate_presence_of(:name)
      should validate_presence_of(:auth_token)
    end

    it 'validates associations/relations' do
      should have_many(:posts)
    end
  end
end
