class ServicesController < ApplicationController
  include ServiceRoles

  before_action :authenticate_admin!
  before_action :set_service,
                only: [
                  :check_connectivity,
                  :destroy,
                  :edit,
                  :refresh,
                  :show,
                  :update
                ]
  before_action :set_roles # defined in 'concerns/service_roles.rb'

  # GET /services
  def index
    @services = {}
    @roles.each do |role|
      @services[role] = Service.where(role: role)
    end
  end

  # GET /services/iterate
  def role_services
    role = params[:role]
    raise ActionController::RoutingError.new('Not Found') unless Service.roles.keys.include?(role)
    @role_services = Service.where(role: role)
  end

  # GET /services/1
  def show
  end

  # GET /services/new
  def new
    uri = params[:uri]
    url = "#{params[:protocol]}://#{uri}"

    @service = Service.new_from_url(url)
    flash_error = new_service_flash_text(uri)
    flash[:error] = flash_error if flash_error

    redirect_to services_url if !@service || @service.errors.any?
  end

  # GET /services/1/edit
  def edit
  end

  # GET /services/1/check_connectivity
  def check_connectivity
    render json: { serviceIsAvailable: @service.is_available? },
           status: 200
  end

  # POST /services
  def create
    @service = Service.new(converted_attributes)
    if @service.save
      redirect_to services_url,
                  notice: I18n.t('services.create.success')
    else
      flash.now[:error] = I18n.t('services.create.error')
      render :new
    end
  end

  # PATCH/PUT /services/1
  def update
    if @service.update(converted_attributes)
      redirect_to services_url,
                  notice: I18n.t('services.update.success')
    else
      flash.now[:error] = I18n.t('services.update.error')
      render :edit
    end
  end

  # GET /services/1/refresh
  def refresh
    if @service.update_from_url(@service.url)
      redirect_to edit_service_path(@service),
                  notice: I18n.t('services.refresh.success')
    else
      error_redirect_to_edit_service_path
    end
  rescue
    error_redirect_to_edit_service_path
  end

  # DELETE /services/1
  def destroy
    @service.destroy
    redirect_to services_url,
                notice: I18n.t('services.destroy.success')
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_service
      @service = Service.find(params[:id])
    end

    # generate a meaningful flash text in case of any error for service#new
    def new_service_flash_text(uri)
      if @service
        @service.validate
        url_error = @service.errors.details[:url].first
        flash_text = I18n.t('services.searching.already-taken-url')
        return flash_text if url_error && url_error[:error] == :taken
      else
        return I18n.t('services.searching.general-error') if uri.present?
        return I18n.t('services.searching.no-url')
      end
      nil
    end

    def error_redirect_to_edit_service_path
      flash[:error] = I18n.t('services.refresh.error')
      redirect_to edit_service_path(@service)
    end

    def converted_attributes
      interface_type_ids = service_params[:interface_types]
      return service_params unless interface_type_ids and interface_type_ids.any?

      converted_params = service_params
      interface_types = []

      interface_type_ids.each do |interface_type_id|
        interface_types << InterfaceType.find(interface_type_id)
      end

      converted_params[:interface_types] = interface_types
      converted_params
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def service_params
      interface_types = params[:service][:interface_types]
      permitted_params = params.require(:service).permit(
        :role,
        :description,
        :problem_id,
        :url,
        :title,
        :version,
        interface_types: []
      )
      permitted_params[:interface_types] -= [''] if interface_types
      permitted_params
    end
end
