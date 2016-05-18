class ServicesController < ApplicationController
  before_action :set_service, only: [:show, :edit, :check_connectivity, :update, :destroy]
  before_action :set_roles

  # GET /services
  def index
    @services = {}
    Service.roles.keys.each do |role|
      @services[role] = Service.where(role: role)
    end
  end

  # GET /services/active_learning
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
    url = "#{params[:protocol]}://#{params[:uri]}"
    @service = Service.new_from_url(url)
    unless @service
      flash[:error] = I18n.t('services.error-searching')
      redirect_to services_url
    end
  end

  # GET /services/1/edit
  def edit
  end

  # GET /services/1/check_connectivity
  def check_connectivity
    # render json: { serviceIsAvailable: @service.is_available }, status: 200

    # use this to simulate connectivities:
    sleep (500 + rand(3000)) / 1000.0
    if [true, false].sample
      render json: { serviceIsAvailable: [true, false].sample }, status: 200
    else
      render json: { serviceIsAvailable: [true, false].sample }, status: 500
    end
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

    def set_roles
      @roles = Service.roles.keys
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def service_params
      params.require(:service).permit(:role, :description, :problem_id, :url, :title, :version)
    end
end
