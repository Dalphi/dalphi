class SessionsController < Devise::SessionsController
  before_action :set_default_email

  private

  def set_default_email
    @default_email = params[:email]
  end
end
