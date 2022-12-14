# frozen_string_literal: true

# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

# (1..10).each do |i|
#   User.create(email: "user#{i}@gmail.com", name: "name #{i}")
#   Post.create(title: "title #{i}", content: "content #{i}", published: true, user_id: i)
# end

user1 = FactoryBot.create(:user)
user2 = FactoryBot.create(:user)

20.times do |i|
  if i <= 10
    if i <= 5
      FactoryBot.create(:published_post, user_id: user1.id)
    else
      FactoryBot.create(:draft_post, user_id: user1.id)
    end
  end

  if i > 10
    if i > 10 && i <= 15
      FactoryBot.create(:published_post, user_id: user2.id)
    else
      FactoryBot.create(:draft_post, user_id: user2.id)
    end
  end
end
