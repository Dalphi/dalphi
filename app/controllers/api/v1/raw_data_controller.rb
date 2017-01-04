module API
  module V1
    class RawDataController < BaseController
      before_action :set_raw_datum,
                    only: [
                      :show,
                      :update,
                      :destroy
                    ]

      # GET /api/v1/raw_data/1
      def show
        render json: @raw_datum.relevant_attributes
      end

      # POST /api/v1/raw_data
      def create
        ActiveRecord::Base.transaction do
          raw_data = []
          raw_data_params.each do |rd_params|
            @raw_datum = RawDatum.create_with_safe_filename Project.find(rd_params[:project_id]),
                                                            {
                                                              filename: rd_params[:data].original_filename,
                                                              path: rd_params[:data].tempfile
                                                            }
            raise 'invalid' unless @raw_datum
            raw_data << @raw_datum.relevant_attributes
          end
          raw_data = raw_data.first if raw_data.count == 1
          render status: 200,
                 json: raw_data
        end
      rescue ArgumentError
        return_parameter_type_mismatch
      rescue
        render status: 400,
               json: {
                 message: I18n.t('api.raw_datum.create.error')
               }
      end

      # PATCH/PUT /api/v1/raw_data/1
      def update
        if @raw_datum.update_with_safe_filename({
                                                  filename: raw_datum_params[:data].original_filename,
                                                  path: raw_datum_params[:data].tempfile
                                                })
          render json: @raw_datum.relevant_attributes
        else
          render status: 400,
                 json: {
                   message: I18n.t('api.raw_datum.update.error'),
                   validationErrors: @raw_datum.errors.full_messages
                 }
        end
      rescue ArgumentError
        return_parameter_type_mismatch
      end

      def destroy
        relevant_attributes = @raw_datum.relevant_attributes
        @raw_datum.destroy
        render status: 200,
               json: relevant_attributes
      end

      private

      def set_raw_datum
        @raw_datum = RawDatum.find(params[:id])
      end

      def raw_data_params
        converted_params = []
        params_raw_data = params[:raw_data]
        if params_raw_data.present?
          params_raw_data.each do |raw_datum|
            converted_params << raw_datum.permit!
          end
        else
          converted_params << raw_datum_params
        end
        converted_params
      end

      def raw_datum_params
        parameters = params.require(:raw_datum).permit(
          :shape,
          :data,
          :project_id
        )
        parameters
      end
    end
  end
end
