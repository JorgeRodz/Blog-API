# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Post, type: :model do
  describe 'validations and relations - ' do
    it 'validate presence of required files' do
      should validate_presence_of(:title)
      should validate_presence_of(:content)
      should validate_presence_of(:user_id)
    end

    it 'validates associations/relations' do
      should belong_to(:user)
    end
  end
end
