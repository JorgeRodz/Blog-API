# frozen_string_literal: true

# This methods are generally used on the controllers
# In order to serialize what information will include in the JSON response of a post
class PostSerializer < ActiveModel::Serializer
  attributes :id, :title, :content, :published, :author

  # Defining the :author key
  def author
    user = object.user # Here we make reference to the post object itself, as we know a post contains user information due to the relation among the models
    {
      name: user.name,
      email: user.email,
      id: user.id
    }
  end
end
