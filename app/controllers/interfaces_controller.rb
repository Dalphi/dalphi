class InterfacesController < ApplicationController
  before_action :set_interface, only: [:show, :edit, :update, :destroy]
  before_action :set_interface_types, only: [:index, :edit, :new]
  before_action :set_problem_identifiers, only: [:edit, :new]

  # GET /interfaces
  def index
    @interfaces = {}
    @interface_types.each do |interface_type|
      @interfaces[interface_type] = Interface.where(interface_type: interface_type)
    end
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
    @interface = Interface.new(interface_params)
    if @interface.save
      redirect_to @interface, notice: 'Interface was successfully created.'
    else
      render :new
    end
  end

  # PATCH/PUT /interfaces/1
  def update
    if @interface.update(interface_params)
      redirect_to @interface, notice: 'Interface was successfully updated.'
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

    def set_interface_types
      exemplary_interfaces = Interface.select(:interface_type).distinct
      @interface_types = exemplary_interfaces.map { |interface| interface.problem_id }.compact
    end

    def set_problem_identifiers
      @problem_identifiers = Service::problem_identifiers
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def interface_params
      params.fetch(:interface, {})
    end
end
