class ProjectsController < ApplicationController
  include ServiceRoles

  before_action :set_project, only: [
    :iterate,
    :check_interfaces,
    :check_problem_identifiers,
    :destroy,
    :edit,
    :merge,
    :show,
    :update,
    :update_service
  ]
  before_action :set_roles # defined in 'concerns/service_roles.rb'
  before_action :set_available_services, only: [
    :create,
    :edit,
    :new,
    :show
  ]
  before_action :set_interfaces, only: [
    :create,
    :edit,
    :new
  ]

  # GET /projects
  def index
    objects_per_page = Rails.configuration.x.dalphi['paginated-objects-per-page']['projects']
    @projects = Project.where(user: current_user)
                       .paginate(
                         page: params[:page],
                         per_page: objects_per_page
                       )
  end

  # GET /projects/1
  def show
  end

  # GET /projects/new
  def new
    @project = Project.new
    @project.connect_services
  end

  # GET /projects/1/edit
  def edit
  end

  # POST /projects
  def create
    @project = Project.new(params_with_associated_models)
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
    if @project.update(params_with_associated_models)
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

  # GET /projects/1/check_interfaces
  def check_interfaces
    render json: { selectedInterfaces: @project.selected_interfaces },
           status: 200
  end

  # POST /projects/1/iterate
  def iterate
    generate_annotation_documents(@project.iterate_data)
    if @annotation_documents
      record_count, error_count = save_annotation_documents
      flash[:notice] = I18n.t 'projects.iterate.success',
                              success_count: (record_count - error_count),
                              record_count: record_count
      redirect_to project_annotation_documents_path(@project)
    else
      redirect_iterate_with_flash
    end
  end

  # POST /projects/1/merge
  def merge
    merge_result = merge_annotation_documents
    if merge_result
      record_count, error_count = merge_result
      flash[:notice] = I18n.t 'projects.merge.success',
                              success_count: (record_count - error_count),
                              record_count: record_count
      redirect_to project_annotation_documents_path(@project)
    else
      redirect_merge_with_flash
    end
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
      @interfaces = {}
      return unless @project

      associated_problem_identifier = @project.associated_problem_identifiers.first
      @project.necessary_interface_types.each do |interface_type|
        @interfaces[interface_type] = Interface.select do |interface|
          interface.interface_type == interface_type &&
          interface.associated_problem_identifiers.include?(associated_problem_identifier)
        end
      end
      @interfaces
    end

    def generate_annotation_documents(raw_data)
      @annotation_documents = false
      iterate_service = @project.iterate_service
      response = json_post_request(iterate_service.url, raw_data)

      @annotation_documents = JSON.parse(response.body) if response.kind_of? Net::HTTPSuccess
      @annotation_documents
    rescue
      @annotation_documents = false
    end

    def save_annotation_documents
      record_count = 0
      error_count = 0
      @annotation_documents.each do |annotation_document|
        new_annotation_document = AnnotationDocument.new(annotation_document)
        error_count += 1 unless new_annotation_document.save
        record_count += 1
      end
      return record_count, error_count
    end

    def merge_annotation_documents
      record_count = error_count = 0
      @project.merge_data.each do |merge_datum|
        merge_service = @project.merge_service
        response = json_post_request(merge_service.url, merge_datum)

        if response.kind_of? Net::HTTPSuccess
          process_merged_data(JSON.parse(response.body))
        else
          error_count += 1
        end
        record_count += 1
      end

      return record_count, error_count
    rescue
      false
    end

    def process_merged_data(response_body)
      @project.update_merged_raw_datum(response_body)
      AnnotationDocument.where(raw_datum_id: response_body['raw_datum_id']).delete_all
    end

    def params_with_associated_models
      new_params = project_params

      @roles.each do |role|
        service_symbol = "#{role}_service".to_sym
        new_params[service_symbol] = Service.find_by_id(project_params[service_symbol])
      end

      add_interfaces_to_params(new_params)
    end

    # this method smells of :reek:UtilityFunction
    def add_interfaces_to_params(params)
      interfaces = []
      params_interface = params[:interfaces]
      params_interface.values.each do |interface_id|
        interfaces << Interface.find(interface_id) if interface_id != ''
      end if params_interface
      params[:interfaces] = interfaces
      params
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def project_params
      params.require(:project).permit(
        :iterate_service,
        :data,
        :description,
        :machine_learning_service,
        :merge_service,
        :title
      ).tap do |whitelisted|
        whitelisted[:interfaces] = params[:project][:interfaces]
      end
    end

    def redirect_iterate_with_flash
      flash[:error] = I18n.t('projects.iterate.error')
      redirect_to project_annotation_documents_path(@project)
    end

    def redirect_merge_with_flash
      flash[:error] = I18n.t('projects.merge.error')
      redirect_to project_annotation_documents_path(@project)
    end

    # this method smells of :reek:UtilityFunction
    def json_post_request(url, data)
      uri = URI.parse(url)
      http = Net::HTTP.new(uri.host, uri.port)
      request = Net::HTTP::Post.new uri.request_uri,
                                    { 'Content-Type' => 'application/json' }
      request.body = data.to_json(except: %w(created_at updated_at project_id requested_at))
      http.request(request)
    end
end
