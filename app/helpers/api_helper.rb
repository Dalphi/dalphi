module APIHelper
  def response_with_auth_token(response)
    {
      response: response,
      auth_token: ApplicationController.generate_auth_token
    }.to_json
  end
end
