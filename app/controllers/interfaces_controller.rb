class InterfacesController < ApplicationController
  before_action :set_tempfiles, only: [:create, :update]
  before_action :set_interface, only: [:show, :edit, :update, :destroy, :refresh]
  before_action :set_problem_identifiers, only: [:edit, :new, :create, :update]

  # GET /interfaces
  def index
    @interfaces = Interface.all.group_by(&:interface_type)
  end

  # GET /interfaces/1
  def show
    @container_class = Rails.configuration.x.dalphi['annotation-interface']['container-class-name']
  end

  # GET /interfaces/new
  def new
    @interface = Interface.new
  end

  # GET /interfaces/1/edit
  def edit
  end

  # POST /interfaces
  def create
    begin
      @interface = Interface.new(converted_attributes)
      if @interface.save
        redirect_to edit_interface_path(@interface),
                    notice: t('interfaces.action.create.success')
      else
        flash[:error] = t('interfaces.action.create.error')
        render :new
      end
    ensure
      unset_files(@tempfiles)
    end
  end

  # POST /interfaces/1
  def refresh
    @interface.save!
    redirect_to edit_interface_path(@interface),
                notice: t('interfaces.action.refresh.success')
  end

  # PATCH/PUT /interfaces/1
  def update
    begin
      if @interface.update(converted_attributes)
        flash[:notice] = t('interfaces.action.update.success')
      else
        flash[:error] = t('interfaces.action.update.error')
      end
      render :edit
    ensure
      unset_files(@tempfiles)
    end
  end

  # DELETE /interfaces/1
  def destroy
    @interface.destroy
    redirect_to interfaces_url,
                notice: t('interfaces.action.destroy.success')
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_interface
      @interface = Interface.find(params[:id])
    end

    def set_problem_identifiers
      @problem_identifiers = Service::problem_identifiers
    end

    def converted_attributes
      associated_problems = interface_params['associated_problem_identifiers']
      new_params = interface_params
      new_params['associated_problem_identifiers'] = associated_problems.strip
                                                                        .split(', ')
                                                                        .uniq
      %w(template java_script stylesheet).each do |resource|
        new_params[resource] = string_to_filestream(resource)
      end
      new_params
    end

    def set_tempfiles
      @tempfiles = {}
      %w(template java_script stylesheet).each do |resource|
        @tempfiles[resource] = Tempfile.new(resource)
      end
    end

    # this method smells of :reek:UtilityFunction
    def unset_files(files)
      files.each do |_, file|
        file.close
        file.unlink
      end
    end

    def string_to_filestream(resource)
      tempfile = @tempfiles[resource]
      tempfile.write(interface_params[resource])
      tempfile.rewind
      tempfile
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def interface_params
      params.require(:interface).permit(
        :template,
        :java_script,
        :stylesheet,
        :title,
        :interface_type,
        :associated_problem_identifiers
      )
    end
end
