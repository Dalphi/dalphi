class AnnotatorsController < ApplicationController
  before_action :set_annotator, only: [:show, :edit, :update, :destroy]
  before_action :set_project

  # GET /annotators
  # GET /projects/1/annotators
  def index
    @annotator = Annotator.new
    objects_per_page = Rails.configuration.x.dalphi['paginated-objects-per-page']['annotators']
    ids = Annotator.all
                   .select { |annotator| !@project || annotator.projects.include?(@project) }
                   .map(&:id)
    @unassigned_annotators = Annotator.where.not(id: ids)
    @annotators = Annotator.where(id: ids)
                           .order(name: :asc)
                           .paginate(
                             page: params[:page],
                             per_page: objects_per_page
                           )
  end

  # POST /annotators
  def create
    @annotator = Annotator.new(annotator_params)
    if @annotator.save
      redirect_to annotators_path, notice: I18n.t('annotators.action.create.success')
    else
      flash.now[:error] = I18n.t('simple_form.error_notification.default_message')
      render :new
    end
  end

  # GET /projects/1/annotators/1
  def show
  end

  # GET /annotators/1/edit
  def edit
  end

  # PATCH /annotators/1
  def update
    if @annotator.update(annotator_params)
      redirect_to annotators_path, notice: I18n.t('annotators.action.update.success')
    else
      flash.now[:error] = I18n.t('simple_form.error_notification.default_message')
      render :edit
    end
  end

  # DELETE /annotators/1
  def destroy
    if @project
      @annotator.projects.delete(@project.id)
      redirect_to project_annotators_path(@project),
                  notice: I18n.t('annotators.action.unassign.success')
    else
      @annotator.destroy
      redirect_to annotators_path, notice: I18n.t('annotators.action.destroy.success')
    end
  end

  private

  def set_annotator
    @annotator = Annotator.find(params[:id])
  end

  def set_project
    project_id = params[:project_id]
    @project = Project.find(project_id) if project_id
  end

  def annotator_params
    tmp_params = params.require(:annotator).permit(
      :name,
      :email,
      :password
    )
    tmp_params.except!(:password) unless params[:annotator][:password].present?
    tmp_params
  end
end
