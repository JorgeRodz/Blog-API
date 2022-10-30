# frozen_string_literal: true

FactoryBot.define do
  factory :post do
    title { Faker::Lorem.sentence }
    content { Faker::Lorem.paragraph }
    published do
      r = rand(0..1)
      r == 1
    end
    user
  end
end
