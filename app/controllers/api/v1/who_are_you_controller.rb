module API
  module V1
    class WhoAreYouController < BaseController
      include Swagger::Blocks

      swagger_path '/who_are_you' do
        operation :get do
          key :description, 'Returns a service description of this webapp'
          key :operationId, 'whoAreYou'
          key :produces, [
            'application/json',
          ]
          key :tags, [
            'WhoAreYou'
          ]
          response 200 do
            key :description, 'webapp response'
          end
          response :default do
            key :description, 'unexpected error'
          end
        end
      end

      def who_are_you
        render json: service_hash
      end

      private

      def service_hash
        {
          role: 'webapp',
          title: 'Dalphi',
          description: "The Ruby on Rails Dalphi webapp\
                       for user interaction and service intercommunication",
          problem_id: 'ner',
          url: root_url,
          version: '1.0'
        }
      end
    end
  end
end
