class RawDataController < ApplicationController
  before_action :set_raw_datum, only: [:show, :edit, :update, :destroy]
  before_action :set_project
  before_action :set_raw_data_shapes

  # GET /raw_data
  def index
    @raw_data = RawDatum.all
  end

  # GET /raw_data/1
  def show
  end

  # GET /raw_data/new
  def new
    @raw_datum = RawDatum.new
  end

  # GET /raw_data/1/edit
  def edit
  end

  # POST /raw_data
  def create
    @raw_datum = RawDatum.new(raw_datum_params)
    if @raw_datum.save
      redirect_to project_raw_data_path(@project), notice: 'Raw datum was successfully created.'
    else
      render :new
    end
  end

  # PATCH/PUT /raw_data/1
  def update
    if @raw_datum.update(raw_datum_params)
      redirect_to project_raw_data_path(@project), notice: 'Raw datum was successfully updated.'
    else
      render :edit
    end
  end

  # DELETE /raw_data/1
  def destroy
    @raw_datum.destroy
    redirect_to project_raw_data_path(@project), notice: 'Raw datum was successfully destroyed.'
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_raw_datum
      @raw_datum = RawDatum.find(params[:id])
    end

    def set_project
      @project = Project.find(params[:project_id])
    end

    def set_raw_data_shapes
      @raw_data_shapes = RawDatum::SHAPES
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def raw_datum_params
      params.require(:raw_datum).permit(:shape)
    end
end
