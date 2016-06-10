module API
  module V1
    class WhoAreYouController < BaseController
      include Swagger::Blocks

      swagger_path '/' do
        operation :get do
          key :description, 'Identifies the service that is operating at this URL'
          key :operationId, 'whoAreYou'
          key :produces, [
            'application/json',
          ]
          key :tags, [
            'WhoAreYou'
          ]
          response 200 do
            key :description, 'service response'
            schema do
              key :'$ref', :Service
            end
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
          description: 'The Ruby on Rails Dalphi webapp ' \
                       'for user interaction and service intercommunication',
          problem_id: 'ner',
          url: root_url,
          version: '1.0'
        }
      end
    end
  end
end
