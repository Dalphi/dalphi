class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  # protect_from_forgery with: :exception
  protect_from_forgery with: :null_session
  before_action :authenticate_user!
  before_action :set_locale
  before_action :set_turbolinks
  before_action :bake_breadcrumbs
  before_action :set_title
  before_action :set_copyright_year

  private

  def set_locale
    I18n.locale = params[:locale].to_sym
  rescue
    I18n.locale = :en
  end

  def set_turbolinks
    blacklist = [
      'projects#show',
      'annotations#annotate'
    ]
    @use_turbolinks = !blacklist.include?("#{controller_name}##{action_name}")
  end

  def bake_breadcrumbs
    @breadcrumbs = []
    bakery = BreadcrumbBakery.new(request)
    @breadcrumbs = bakery.breadcrumbs
  end

  def set_title
    @site_title = I18n.t('site-title.default')
    @site_title = I18n.t(
      'site-title.schema',
      title: @site_title,
      current_page: @breadcrumbs.last[:label].capitalize
    ) if @breadcrumbs.any?
  end

  def set_copyright_year
    require 'date'
    @current_year = Date.today.strftime("%Y")
  end

  # This method smells of :reek:UtilityFunction
  def default_url_options(options = {})
    { locale: I18n.locale }.merge options
  end
end
