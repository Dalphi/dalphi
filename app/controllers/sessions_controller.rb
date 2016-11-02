class SessionsController < Devise::SessionsController
  before_action :set_default_email
  before_action :before_login,
                only: :create

  private

  def before_login
    sign_out current_admin if current_admin
    sign_out current_annotator if current_annotator
  end

  def set_default_email
    @default_email = params[:email]
  end
end
