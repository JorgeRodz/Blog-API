# frozen_string_literal: true

# This class is responsible for handling the search logic
# The logic of this class is available to all controllers
class PostsSearchService
  # class method in order to search posts with an specific string
  def self.search(curr_posts, query)
    curr_posts.where("title like '%#{query}%'")
  end
end
