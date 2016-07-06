class ProjectsController < ApplicationController
  include ServiceRoles

  before_action :set_project, only: [
    :bootstrap,
    :destroy,
    :edit,
    :show,
    :update_service,
    :check_problem_identifiers,
    :update
  ]
  before_action :set_roles # defined in 'concerns/service_roles.rb'
  before_action :set_available_services, only: [
    :edit,
    :new,
    :show
  ]
  before_action :set_interfaces

  # GET /projects
  def index
    @projects = Project.all
  end

  # GET /projects/1
  def show
  end

  # GET /projects/new
  def new
    @project = Project.new
  end

  # GET /projects/1/edit
  def edit
  end

  # POST /projects
  def create
    @project = Project.new(params_with_service_instances)
    @project.user = current_user
    @project.connect_services
    if @project.save
      redirect_to project_raw_data_path(@project), notice: I18n.t('projects.action.create.success')
    else
      flash[:error] = I18n.t('simple_form.error_notification.default_message')
      render :new
    end
  end

  # PATCH/PUT /projects/1
  def update
    if @project.update(params_with_service_instances)
      redirect_to project_path(@project), notice: I18n.t('projects.action.update.success')
    else
      flash[:error] = I18n.t('simple_form.error_notification.default_message')
      render :edit
    end
  end

  # DELETE /projects/1
  def destroy
    @project.destroy
    redirect_to projects_path, notice: I18n.t('projects.action.destroy.success')
  end

  # GET /projects/1/check_compatibility
  def check_problem_identifiers
    render json: { associatedProblemIdentifiers: @project.associated_problem_identifiers },
           status: 200
  end

  # GET /projects/1/bootstrap
  def bootstrap
    bootstrap_service = @project.bootstrap_service
    uri = URI.parse(bootstrap_service.url)
    http = Net::HTTP.new(uri.host, uri.port)
    request = Net::HTTP::Post.new uri.request_uri,
                                  { 'Content-Type' => 'application/json' }

    request.body = @project.bootstrap_data.to_json
    response = http.request(request)

    if response.kind_of? Net::HTTPSuccess
      flash[:notice] = I18n.t('projects.bootstrap.success')
      redirect_to project_path(@project)
    else
      redirect_bootstrap_with_flash
    end

  rescue
    redirect_bootstrap_with_flash
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_project
      @project = Project.find(params[:id])
    end

    def set_available_services
      @available_services = {}
      @roles.each do |role|
        role_symbol = role.to_sym
        @available_services[role_symbol] = Service.where(role: role_symbol)
      end
    end

    def set_interfaces
      associated_problem_identifier = @project.associated_problem_identifiers.first
      @interfaces = Interface.select do |interface|
        interface if interface
                       .associated_problem_identifiers
                       .include?(associated_problem_identifier)
      end
      @interfaces = @interfaces.group_by(&:interface_type)
    end

    def params_with_service_instances
      new_params = project_params

      @roles.each do |role|
        service_symbol = "#{role}_service".to_sym
        service_instance = Service.find_by_id(project_params[service_symbol])
        new_params[service_symbol] = service_instance
      end

      new_params
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def project_params
      params.require(:project).permit(
        :active_learning_service,
        :bootstrap_service,
        :data,
        :description,
        :machine_learning_service,
        :merge_service,
        :title
      )
    end

    def redirect_bootstrap_with_flash
      flash[:error] = I18n.t('projects.bootstrap.error')
      redirect_to project_path(@project)
    end
end
