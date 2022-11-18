# frozen_string_literal: true

# In order to storage the current logged user
class Current < ActiveSupport::CurrentAttributes
  attribute :user  # Attributes that will be accessible, in this case all the user attributes
end
