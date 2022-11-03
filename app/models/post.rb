# frozen_string_literal: true

class Post < ApplicationRecord
  belongs_to :user

  validates :title, presence: true
  validates :content, presence: true
  validates :published, inclusion: { in: [true, false] } # Valid presence of boolean
  validates :user_id, presence: true
end
