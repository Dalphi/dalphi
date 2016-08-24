class RawDataController < ApplicationController
  before_action :set_raw_datum, only: [:show, :edit, :update, :destroy]
  before_action :set_project

  # GET /raw_data
  def index
    @raw_data = RawDatum.where(project: @project)
    respond_to do |format|
      format.js { render json: @raw_data }
      format.zip do
        timestamp = Time.zone.now.strftime('%Y-%m-%d-%H-%M-%S')
        begin
          file = Tempfile.new('raw-datum-zip')
          send_data @project.zip(file),
                    filename: "#{@project.title.parameterize}-raw-data-#{timestamp}.zip",
                    disposition: 'inline',
                    type: 'application/zip'
        ensure
          file.close
          file.unlink
        end
      end
      format.html do
        raw_data_per_page = Rails.configuration.x.dalphi['paginated-objects-per-page']['raw-data']
        @raw_data = @raw_data
                      .paginate(
                        page: params[:page],
                        per_page: raw_data_per_page
                      )
      end
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
    data = raw_datum_params[:data]
    batch_result = RawDatum.batch_process @project,
                                          data
    if batch_result[:success].any?
      redirect_to project_raw_data_path(@project),
                  notice: I18n.t('raw-data.action.create.success')
    else
      @raw_datum = RawDatum.new
      flash[:error] = I18n.t('simple_form.error_notification.default_message')
      render :new
    end
  end

  # PATCH/PUT /raw_data/1
  def update
    if @raw_datum.update(raw_datum_params)
      redirect_to project_raw_data_path(@project),
                  notice: I18n.t('raw-data.action.update.success')
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
      data = { data: [] }
      data = :data if action_name == 'update'
      params.require(:raw_datum).permit(:shape, data)
    end
end
