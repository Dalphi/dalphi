module API
  module V1
    class WhoAreYouController < BaseController
      Swagger::Docs::Generator::set_real_methods

      swagger_controller :who_are_you, 'WhoAreYou'

      swagger_api :who_are_you do
        summary "Fetches all User items"
        notes "This lists all the active users"
        response :unauthorized
        response :not_acceptable, "The request you made is not acceptable"
        response :requested_range_not_satisfiable
      end

      def who_are_you
        render json: service_hash
      end

      private

      def service_hash
        {
          role: 'webapp',
          title: 'Dalphi',
          description: 'The Ruby on Rails Dalphi webapp for user interaction and service intercommunication',
          problem_id: 'ner',
          url: root_url,
          version: '1.0'
        }
      end
    end
  end
end
