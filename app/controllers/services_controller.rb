class ServicesController < ApplicationController
  include ServiceRoles

  before_action :set_service, only: [:show, :edit, :update, :destroy]
  before_action :set_roles # defined in 'concerns/service_roles.rb'

  # GET /services
  def index
    @services = {}
    @roles.each do |role|
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
      ap @service
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def service_params
      params.require(:service).permit(:role, :description, :problem_id, :url, :title, :version)
    end
end
