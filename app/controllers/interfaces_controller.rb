class InterfacesController < ApplicationController
  before_action :set_interface, only: [:show, :edit, :update, :destroy]
  before_action :set_problem_identifiers, only: [:edit, :new]

  # GET /interfaces
  def index
    @interfaces = {}
    exemplary_interfaces = Interface.select(:interface_type).distinct
    exemplary_interfaces.map { |interface| interface.interface_type }
                        .compact
                        .each do |interface_type|
                          @interfaces[interface_type] = Interface.where(
                            interface_type: interface_type
                          )
                        end
    ap @interfaces
  end

  # GET /interfaces/1
  def show
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
      redirect_to interfaces_path, notice: 'Interface was successfully created.'
    else
      render :new
    end
  end

  # PATCH/PUT /interfaces/1
  def update
    if @interface.update(converted_attributes)
      redirect_to interfaces_path, notice: 'Interface was successfully updated.'
    else
      render :edit
    end
  end

  # DELETE /interfaces/1
  def destroy
    @interface.destroy
    redirect_to interfaces_url, notice: 'Interface was successfully destroyed.'
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
      new_params
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
