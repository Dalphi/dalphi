module API
  module V1
    class StatisticsController < BaseController
      include Swagger::Blocks

      before_action :set_statistic,
                    only: [
                      :show,
                      :update,
                      :destroy
                    ]

      swagger_path '/statistics/{id}' do
        operation :get do
          key :comsumes, ['application/json']
          key :description, I18n.t('api.statistics.show.description')
          key :operationId, 'statistic_read'
          key :produces, ['application/json']
          key :tags, ['Statistics']

          parameter name: :id do
            key :in, :path
            key :required, true
            key :type, :integer
            key :format, :int32
          end

          response 200 do
            key :description, I18n.t('api.statistic.show.response-200')
            schema do
              key :'$ref', :Statistic
            end
          end

          response 400 do
            key :description, I18n.t('api.statistic.show.response-400')
            schema do
              key :'$ref', :ErrorModel
            end
          end
        end
      end

      swagger_path '/statistics' do
        operation :post do
          key :comsumes, ['application/json']
          key :description, I18n.t('api.statistic.create.description')
          key :operationId, 'statistic_create'
          key :produces, ['application/json']
          key :tags, ['Statistics']

          parameter name: :json_object do
            key :in, :body
            key :required, true
            schema do
              key :type, :array
              items do
                key :'$ref', :Statistic
              end
            end
          end

          response 200 do
            key :description, I18n.t('api.statistic.create.response-200')
            schema do
              key :type, :array
              items do
                key :'$ref', :Statistic
              end
            end
          end

          response 400 do
            key :description, I18n.t('api.statistic.create.response-400')
            schema do
              key :'$ref', :ErrorModel
            end
          end
        end
      end

      swagger_path '/statistics/{id}' do
        operation :patch do
          key :comsumes, ['application/json']
          key :description, I18n.t('api.statistic.update.description')
          key :operationId, 'statistic_update'
          key :produces, ['application/json']
          key :tags, ['Statistics']

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
              key :'$ref', :Statistic
            end
          end

          response 200 do
            key :description, I18n.t('api.statistic.update.response-200')
            schema do
              key :'$ref', :Statistic
            end
          end

          response 400 do
            key :description, I18n.t('api.statistic.update.response-400')
            schema do
              key :'$ref', :ErrorModel
            end
          end
        end
      end

      swagger_path '/statistics/{id}' do
        operation :delete do
          key :comsumes, ['application/json']
          key :description, I18n.t('api.statistic.destroy.description')
          key :operationId, 'statistic_destroy'
          key :produces, ['application/json']
          key :tags, ['Statistics']

          parameter name: :id do
            key :in, :path
            key :required, true
            key :type, :integer
            key :format, :int32
          end

          response 200 do
            key :description, I18n.t('api.statistic.destroy.response-200')
            schema do
              key :'$ref', :Statistic
            end
          end

          response 400 do
            key :description, I18n.t('api.statistic.destroy.response-400')
            schema do
              key :'$ref', :ErrorModel
            end
          end
        end
      end

      # POST /api/v1/statistics
      def create
        ActiveRecord::Base.transaction do
          statistics = []
          statistics_params.each do |ad_params|
            @statistic = Statistic.new(ad_params)
            @statistic.save!
            statistics << @statistic.relevant_attributes
          end
          statistics = statistics.first if statistics.count == 1
          render status: 200,
                 json: statistics
        end
      rescue ArgumentError
        return_parameter_type_mismatch
      rescue
        render status: 400,
               json: {
                 message: I18n.t('api.statistic.create.error')
               }
      end

      # GET /api/v1/statistics/1
      def show
        render json: @statistic.relevant_attributes
      end

      # PATCH/PUT /api/v1/statistics/1
      def update
        if @statistic.update(converted_statistic_params)
          render json: @statistic.relevant_attributes
        else
          render status: 400,
                 json: {
                   message: I18n.t('api.statistic.update.error'),
                   validationErrors: @statistic.errors.full_messages
                 }
        end
      rescue ArgumentError
        return_parameter_type_mismatch
      end

      # DELETE /api/v1/statistics/1
      def destroy
        @statistic.destroy
        render status: 200,
               json: @statistic.relevant_attributes
      end

      private

        def set_statistic
          @statistic = Statistic.find(params[:id])
        rescue
          render status: 400,
                 json: {
                   message: I18n.t('api.statistic.show.error')
                 }
        end

        def return_parameter_type_mismatch
          render status: 400,
                 json: {
                   message: I18n.t('api.statistic.general-errors.parameter-type-mismatch')
                 }
        end

        def statistics_params
          converted_params = []
          params_statistics = params[:statistics]
          if params_statistics.present?
            params_statistics.each do |statistic|
              converted_params << converted_statistic_params(statistic).permit!
            end
          else
            converted_params << converted_statistic_params
          end
          converted_params
        end

        def statistic_params_from_json
          JSON.parse(params['_json'])['statistic']
        end

        def statistic_params
          return statistic_params_from_json if params['_json']
          parameters = params.require(:statistic).permit(
            :id,
            :interface_type,
            :payload,
            :rank,
            :raw_datum_id,
            :skipped
          )
          parameters[:payload] = params[:statistic][:payload]
          parameters
        end

        # this method smells of :reek:FeatureEnvy
        def converted_statistic_params(statistic = nil)
          statistic ||= statistic_params
          statistic['payload'] = statistic['payload'].to_json
          statistic['interface_type'] = InterfaceType.find_or_create_by(
                                                    name: statistic['interface_type']
                                                  )
          statistic
        end
    end
  end
end
