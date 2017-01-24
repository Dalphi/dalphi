class RawDataController < ApplicationController
  # the order of the following before actions matters, since setters rely on each other
  before_action :authenticate_admin!
  before_action :set_project
  before_action :set_raw_data,
                only: [:index, :destroy_all]
  before_action :set_raw_datum,
                only: [:show, :edit, :update, :destroy]

  # GET /raw_data
  def index
    respond_to do |format|
      format.js { render json: @raw_data }
      format.zip do
        raw_data_zip
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
      flash.now[:error] = I18n.t('simple_form.error_notification.default_message')
      render :new
    end
  end

  # PATCH/PUT /raw_data/1
  def update
    if @raw_datum.update(raw_datum_params)
      redirect_to project_raw_data_path(@project),
                  notice: I18n.t('raw-data.action.update.success')
    else
      flash.now[:error] = I18n.t('simple_form.error_notification.default_message')
      render :edit
    end
  end

  # DELETE /raw_data/1
  def destroy
    @raw_datum.destroy
    redirect_to project_raw_data_path(@project), notice: I18n.t('raw-data.action.destroy.success')
  end

  # DELETE /raw_data
  def destroy_all
    @raw_data.destroy_all
    redirect_to project_raw_data_path(@project), notice: I18n.t('raw-data.action.destroy.success')
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_project
      @project = current_role.projects.find(params[:project_id])
    end

    def set_raw_data
      @raw_data = @project.raw_data
    end

    def set_raw_datum
      @raw_datum = @project.raw_data.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def raw_datum_params
      data = { data: [] }
      data = :data if action_name == 'update'
      params.require(:raw_datum).permit(:shape, data)
    end

    def raw_data_zip
      timestamp = Time.zone.now.strftime('%Y-%m-%d-%H-%M-%S')
      begin
        file = Tempfile.new('raw-data-zip')
        send_data @project.zip(file),
                  filename: "#{@project.title.parameterize}-raw-data-#{timestamp}.zip",
                  disposition: 'inline',
                  type: 'application/zip'
      ensure
        file.close
        file.unlink
      end
    end
end
