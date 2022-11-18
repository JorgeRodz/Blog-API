# frozen_string_literal: true

# This factories are used on the tests in order to create fake data
FactoryBot.define do
  factory :user do
    email { Faker::Internet.email }
    name { Faker::Name.name }
  end
end
