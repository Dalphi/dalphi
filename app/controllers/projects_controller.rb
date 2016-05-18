class ProjectsController < ApplicationController
  include ServiceRoles

  before_action :set_project, only: [
    :show,
    :edit,
    :update,
    :destroy,
    :update_service
  ]
  before_action :set_available_services, only: [
    :edit,
    :new
  ]
  before_action :set_roles, only: [:show] # defined in 'cencerns/service_roles.rb'

  # GET /projects
  def index
    @projects = Project.all
  end

  # GET /projects/1
  def show
    @project_services = {}
    @roles.each do |role|
      @project_services[role] = @project.send("#{role}_service")
    end
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

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_project
      @project = Project.find(params[:id])
    end

    def set_available_services
      @available_services = {
        active_learning: Service.where(role: :active_learning),
        bootstrap: Service.where(role: :bootstrap),
        machine_learning: Service.where(role: :machine_learning)
      }
    end

    def params_with_service_instances
      new_params = project_params

      [ :active_learning_service,
        :bootstrap_service,
        :machine_learning_service ].each do |service_symbol|
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
        :title
      )
    end
end
