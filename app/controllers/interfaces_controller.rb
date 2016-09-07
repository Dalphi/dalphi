class InterfacesController < ApplicationController
  before_action :set_interface,
                only: [
                  :show,
                  :edit,
                  :update,
                  :destroy,
                  :interface_type
                ]
  before_action :set_problem_identifiers,
                only: [
                  :edit,
                  :new,
                  :create,
                  :update
                ]

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
    @interface = Interface.new(converted_attributes)
    if @interface.save
      redirect_to interfaces_path,
                  notice: t('interfaces.action.create.success')
    else
      flash[:error] = t('interfaces.action.create.error')
      render :new
    end
  end

  # PATCH/PUT /interfaces/1
  def update
    if @interface.update(converted_attributes)
      flash[:notice] = t('interfaces.action.update.success')
    else
      flash[:error] = t('interfaces.action.update.error')
    end

    interface_type_error = @interface.errors.key? :'interface_type.test_payload'
    render :edit unless interface_type_error
    redirect_to interface_interface_type_path(@interface) if interface_type_error
  end

  # DELETE /interfaces/1
  def destroy
    @interface.destroy
    redirect_to interfaces_url,
                notice: t('interfaces.action.destroy.success')
  end

  # GET /interfaces/1/interface_type
  def interface_type
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_interface
      @interface = Interface.find_by(id: params[:id])
      @interface ||= Interface.find_by(id: params[:interface_id])
    end

    def set_problem_identifiers
      @problem_identifiers = Service::problem_identifiers
    end

    def converted_attributes
      new_params = interface_params
      associated_problems = interface_params['associated_problem_identifiers']
      if associated_problems
        new_params['associated_problem_identifiers'] = associated_problems.strip
                                                                          .split(', ')
                                                                          .uniq
      end
      new_params
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def interface_params
      params.require(:interface).permit(
        :template,
        :java_script,
        :stylesheet,
        :title,
        :associated_problem_identifiers,
        interface_type_attributes: [:id, :name, :test_payload]
      )
    end
end
