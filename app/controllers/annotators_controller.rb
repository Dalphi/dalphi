class AnnotatorsController < ApplicationController
  before_action :set_annotator, only: [:edit, :update, :destroy]

  # GET /annotators
  def index
    objects_per_page = Rails.configuration.x.dalphi['paginated-objects-per-page']['annotators']
    @annotators = Annotator.all
                           .paginate(
                             page: params[:page],
                             per_page: objects_per_page
                           )
  end

  # GET /annotators/new
  def new
    @annotator = Annotator.new
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

  # GET /annotators/1/edit
  def edit
  end

  # PATCH /annotators/1
  def update
  end

  # DELETE /annotators/1
  def destroy
  end

  private

  def set_annotator
    @annotator = Annotator.find(params[:id])
  end

  def annotator_params
    tmp_params = params.require(:annotator).permit(
      :name,
      :email,
      :password
    )
    tmp_params[:password] = SecureRandom.hex
    tmp_params
  end
end
