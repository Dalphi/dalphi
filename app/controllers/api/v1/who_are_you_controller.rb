module API
  module V1
    class WhoAreYouController < BaseController
      Swagger::Docs::Generator::set_real_methods

      swagger_controller :who_are_you, 'WhoAreYou'

      swagger_api :who_are_you do
        summary 'Identifies the service that is operating at this URL'
        response :ok, 'Success', :Service
      end

      swagger_model :Tag do
        description 'A Service object.'
        property_list :role,
                      :string,
                      :required,
                      'Role',
                      ['active_learning', 'bootstrap', 'machine_learning']
        property :title,
                 :string,
                 :required,
                 'Title'
        property :description,
                 :string,
                 :required,
                 'Description'
        property_list :problem_id,
                 :string,
                 :required,
                 'Proplem identifier',
                 ['ner']
        property :url,
                 :string,
                 :required,
                 'URL'
        property :version,
                 :string,
                 :required,
                 'Version'
      end

      def who_are_you
        render json: service_hash
      end

      private

      def service_hash
        {
          role: 'webapp',
          title: 'Dalphi',
          description: 'The Ruby on Rails Dalphi webapp for user interaction \
                       and service intercommunication',
          problem_id: 'ner',
          url: root_url,
          version: '1.0'
        }
      end
    end
  end
end
