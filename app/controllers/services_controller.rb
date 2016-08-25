class ServicesController < ApplicationController
  include ServiceRoles

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
    @service = Service.new(service_params)
    if @service.save
      redirect_to services_url, notice: 'Service was successfully created.'
    else
      render :new
    end
  end

  # PATCH/PUT /services/1
  def update
    if @service.update(service_params)
      redirect_to services_url, notice: 'Service was successfully updated.'
    else
      render :edit
    end
  end

  # GET /services/1/refresh
  def refresh
    new_params = Service.params_from_url(@service.url)
    redirect_target = edit_service_path(@service)

    if @service.update(new_params)
      redirect_to redirect_target,
                  notice: I18n.t('services.refresh.success')
    else
      redirect_to redirect_target,
                  error: I18n.t('services.refresh.error')
    end
  end

  # DELETE /services/1
  def destroy
    @service.destroy
    redirect_to services_url, notice: 'Service was successfully destroyed.'
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
