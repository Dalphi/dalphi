class ProjectsController < ApplicationController
  before_action :set_project, only: [
    :show,
    :edit,
    :update,
    :destroy,
    :update_service
  ]

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
    @available_services = {
      active_learning: Service.where(role: :active_learning),
      bootstrap: Service.where(role: :bootstrap),
      machine_learning: Service.where(role: :machine_learning)
    }
  end

  # POST /projects
  def create
    @project = Project.new(project_params)
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
    if @project.update(project_params)
      redirect_to projects_path, notice: I18n.t('projects.action.update.success')
    else
      flash[:error] = I18n.t('simple_form.error_notification.default_message')
      render :edit
    end
  end

  # PATCH /projects/1/update_services
  def update_service
    service_id = params[:service]
    service_symbol = service_id.to_sym
    service_name = service_id[0..-9].tr('_', ' ').capitalize
    new_service = Service.find(project_params[service_symbol])

    if @project.update({ service_symbol => new_service })
      translation_key = "projects.action.update-service.success"
      redirect_to project_path(@project),
        notice: I18n.t(translation_key, service: service_name)
    else
      render_edit_with_error 'error', service_name
    end

  rescue ActiveRecord::RecordNotFound
    render_edit_with_error 'not-recognized', service_name
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

    # render edit and show error flash if setting a different service went wrong
    def render_edit_with_error(error_key, service_name)
      translation_key = "projects.action.update-service.#{error_key}"
      flash[:error] = I18n.t(translation_key, service: service_name)
      render :edit
    end
end
