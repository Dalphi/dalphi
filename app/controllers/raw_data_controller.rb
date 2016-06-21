class RawDataController < ApplicationController
  before_action :set_raw_datum, only: [:show, :edit, :update, :destroy]
  before_action :set_project

  # GET /raw_data
  def index
    @raw_data = RawDatum.where(project: @project)
    if request.xhr?
      return render json: @raw_data
    end
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
    data = raw_datum_params[:data][1..-1]
    batch_result = RawDatum.batch_process @project, data
    if data.size == 0 || batch_result[:success].empty?
      flash[:error] = I18n.t('simple_form.error_notification.default_message')
      render :new
    else
      redirect_to project_raw_data_path(@project),
                  notice: I18n.t('raw-data.action.create.success')
    end
  end

  # PATCH/PUT /raw_data/1
  def update
    if @raw_datum.update(raw_datum_params)
      redirect_to project_raw_data_path(@project), notice: I18n.t('raw-data.action.update.success')
    else
      flash[:error] = I18n.t('simple_form.error_notification.default_message')
      render :edit
    end
  end

  # DELETE /raw_data/1
  def destroy
    @raw_datum.destroy
    redirect_to project_raw_data_path(@project), notice: I18n.t('raw-data.action.destroy.success')
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_raw_datum
      @raw_datum = RawDatum.find(params[:id])
    end

    def set_project
      @project = Project.find(params[:project_id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def raw_datum_params
      params.require(:raw_datum).permit(:shape, data: [])
    end
end
