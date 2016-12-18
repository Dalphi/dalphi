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
        if params[:statistics].present?
          create_bulk
          render status: 200,
                 json: @statistics
        else
          @statistic = Statistic.new(converted_statistic_params)
          @statistic.save!
          render status: 200,
                 json: @statistic.relevant_attributes
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
        if @statistic.update(statistic_params)
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

      def create_bulk
        @statistics = []
        ActiveRecord::Base.transaction do
          converted_statistics_params.each do |s_params|
            statistic = Statistic.new(s_params)
            statistic.save!
            @statistics << statistic.relevant_attributes
          end
        end
      end

      def statistics_params
        params.permit(statistics: [
            :key,
            :value,
            :iteration_index,
            :project_id,
            raw_data_ids: []
          ]
        )[:statistics]
      end

      def statistic_params
        return statistic_params_from_json if params['_json']
        params.require(:statistic).permit(
          :id,
          :key,
          :value,
          :iteration_index,
          :project_id,
          raw_data_ids: []
        )
      end

      def converted_statistics_params
        s_params = []
        statistics_params.each do |s_param|
          s_params << converted_statistic_params(s_param)
        end
        s_params
      end

      # this method smells of :reek:FeatureEnvy
      def converted_statistic_params(s_params = nil)
        s_params ||= statistic_params
        raw_data_ids = s_params[:raw_data_ids]
        if raw_data_ids.present?
          project_ids = RawDatum.where(id: raw_data_ids).map(&:project_id).uniq
          s_params[:project_id] = project_ids.first if project_ids.count == 1
          s_params.delete :raw_data_ids
        end
        s_params
      end

      def statistic_params_from_json
        JSON.parse(params['_json'])['statistic']
      end
    end
  end
end
