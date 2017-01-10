module API
  module V1
    class RawDataController < BaseController
      include Swagger::Blocks

      before_action :set_raw_datum,
                    only: [
                      :show,
                      :update,
                      :destroy
                    ]

      swagger_path '/raw_data/{id}' do
        operation :get do
          key :comsumes, ['application/json']
          key :description, I18n.t('api.raw_datum.show.description')
          key :operationId, 'raw_datum_read'
          key :produces, ['application/json']
          key :tags, ['RawData']

          parameter name: :id do
            key :in, :path
            key :required, true
            key :type, :integer
            key :format, :int32
          end

          response 200 do
            key :description, I18n.t('api.raw_datum.show.response-200')
            schema do
              key :'$ref', :RawDatum
            end
          end

          response 400 do
            key :description, I18n.t('api.raw_datum.show.response-400')
            schema do
              key :'$ref', :ErrorModel
            end
          end
        end
      end

      # GET /api/v1/raw_data/1
      def show
        render json: @raw_datum.relevant_attributes
      end

      swagger_path '/raw_data' do
        operation :post do
          key :comsumes, ['application/json']
          key :description, I18n.t('api.raw_datum.create.description')
          key :operationId, 'raw_datum_create'
          key :produces, ['application/json']
          key :tags, ['RawData']

          parameter name: :json_object do
            key :in, :body
            key :required, true
            schema do
              key :type, :array
              items do
                key :'$ref', :RawDatum
              end
            end
          end

          response 200 do
            key :description, I18n.t('api.raw_datum.create.response-200')
            schema do
              key :type, :array
              items do
                key :'$ref', :RawDatum
              end
            end
          end

          response 400 do
            key :description, I18n.t('api.raw_datum.create.response-400')
            schema do
              key :'$ref', :ErrorModel
            end
          end
        end
      end

      # POST /api/v1/raw_data
      def create
        ActiveRecord::Base.transaction do
          raw_data = []
          raw_data_params.each do |rd_params|
            @raw_datum = raw_datum_from_params(rd_params)
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

      swagger_path '/raw_data/{id}' do
        operation :patch do
          key :comsumes, ['application/json']
          key :description, I18n.t('api.raw_datum.update.description')
          key :operationId, 'raw_datum_update'
          key :produces, ['application/json']
          key :tags, ['RawData']

          parameter name: :id do
            key :in, :path
            key :required, true
            key :type, :integer
            key :format, :int32
          end

          parameter name: :json_object do
            key :in, :body
            key :required, true
            schema do
              key :'$ref', :RawDatum
            end
          end

          response 200 do
            key :description, I18n.t('api.raw_datum.update.response-200')
            schema do
              key :'$ref', :RawDatum
            end
          end

          response 400 do
            key :description, I18n.t('api.raw_datum.update.response-400')
            schema do
              key :'$ref', :ErrorModel
            end
          end
        end
      end

      # PATCH/PUT /api/v1/raw_data/1
      def update
        raw_datum_params_data = raw_datum_params[:data]
        data = {
                 filename: raw_datum_params_data.original_filename,
                 path: raw_datum_params_data.tempfile
               }
        if @raw_datum.update_with_safe_filename(data)
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

      swagger_path '/raw_data/{id}' do
        operation :delete do
          key :comsumes, ['application/json']
          key :description, I18n.t('api.raw_datum.destroy.description')
          key :operationId, 'raw_datum_destroy'
          key :produces, ['application/json']
          key :tags, ['RawData']

          parameter name: :id do
            key :in, :path
            key :required, true
            key :type, :integer
            key :format, :int32
          end

          response 200 do
            key :description, I18n.t('api.raw_datum.destroy.response-200')
            schema do
              key :'$ref', :RawDatum
            end
          end

          response 400 do
            key :description, I18n.t('api.raw_datum.destroy.response-400')
            schema do
              key :'$ref', :ErrorModel
            end
          end
        end
      end

      def destroy
        relevant_attributes = @raw_datum.relevant_attributes
        @raw_datum.destroy
        render status: 200,
               json: relevant_attributes
      end

      private

      def raw_datum_from_params(rd_params)
        project = Project.find(rd_params[:project_id])
        rd_params_data = rd_params[:data]
        data = {
                 filename: rd_params_data.original_filename,
                 path: rd_params_data.tempfile
               }
        @raw_datum = RawDatum.create_with_safe_filename project, data
        @raw_datum
      end

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
