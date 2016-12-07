module API
  module V1
    class BaseController < ActionController::Base
      before_action :authenticate

      private

      def return_parameter_type_mismatch
        render status: 400,
               json: {
                 message: I18n.t('api.statistic.general-errors.parameter-type-mismatch')
               }
      end

      def authenticate
        if $redis.hdel(:auth_token, params['auth_token']) != 1
          return render json: {
                          error: I18n.t('api-errors.unauthorized'),
                          status: :unauthorized
                        }
        end
      end
    end
  end
end
