class InterfaceTypesController < ApplicationController
  before_action :set_interface_type,
                only: [
                  :edit,
                  :update
                ]

  # GET /interface_types/1/edit
  def edit
  end

  # PATCH/PUT /interface_types/1
  def update
    if @interface_type.update(preprocessed_params)
      flash[:notice] = t('interfaces.action.update.success')
    else
      flash[:error] = t('interfaces.action.update.error')
    end
    redirect_to edit_interface_type_path(@interface_type)
  end

  private
    def set_interface_type
      @interface_type = InterfaceType.find(params[:id])
    end

    def preprocessed_params
      {
        test_payload: interface_type_params[:test_payload].strip
      }
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def interface_type_params
      params.require(:interface_type).permit(
        :test_payload
      )
    end
end
