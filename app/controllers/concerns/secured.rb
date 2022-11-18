module Secured
  extend ActiveSupport::Concern

  def authenticate_user!
    token_regex = /Bearer (\w+)/ # Regex to match the token
    headers = request.headers # Here we get the headers from the request
    # Verify if the Authorization token is valid and match the current user
    if headers['Authorization'].present? && headers['Authorization'].match(token_regex)
      token = headers['Authorization'].match(token_regex)[1]
      # ℹ️ 'Current' is a class that we created in order to storage the current logged user, this class is under the -
      # - 'models' folder, in the 'current.rb' file
      return if (Current.user = User.find_by_auth_token(token)) # if the token correspond to a user we store it to the -
      # - 'Current.user' and exit the method
    end

    # If the token do not match any user token return a 401 Unauthorized response
    render json: { error: 'Not Authorized' }, status: :unauthorized
  end
end
