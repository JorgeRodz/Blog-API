# frozen_string_literal: true

FactoryBot.define do
  # factory for create post with ramdom published value(true or false)
  factory :post do
    title { Faker::Lorem.sentence }
    content { Faker::Lorem.paragraph }
    published do
      r = rand(0..1)
      r == 1
    end
    user
  end

  # factory to create only published posts
  factory :published_post, class: 'Post' do
    title { Faker::Lorem.sentence }
    content { Faker::Lorem.paragraph }
    published { true }
    user
  end
end
