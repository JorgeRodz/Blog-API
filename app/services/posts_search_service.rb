# frozen_string_literal: true

# This class is responsible for handling the search logic
# The logic of this class is available to all controllers
class PostsSearchService
  # class method in order to search posts with an specific string
  def self.search(curr_posts, query)
    posts_ids = Rails.cache.fetch("posts_search/#{query}", expires_in: 1.hour) do
      curr_posts.where("title like '%#{query}%'").map(&:id)
    end

    curr_posts.where(id: posts_ids)
  end
end
