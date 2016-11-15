module DeviseHelper
  def devise_error_messages!
    return '' if admin_signed_in? || resource.errors.empty?
    flash.now[:error] = I18n.t('simple_form.error_notification.default_message')
  end
end
