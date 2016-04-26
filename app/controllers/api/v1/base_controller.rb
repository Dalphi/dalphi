module API
  module V1
    class BaseController < ApplicationController
      include Swagger::Docs::ImpotentMethods

      skip_before_filter :authenticate_user!
      swagger_controller :base, 'Base'

      swagger_api :who_are_you do
        response :ok, :Service
      end

      swagger_model :Service do
        description 'A Service object.'
        property_list :role, :string, :required, 'Role', [:active_learning, :bootstrap, :machine_learning]
        property :title, :string, :required, 'Title'
        property :description, :string, :optional, 'Description'
        property_list :problem_id, :string, :required, 'Capability', [:ner]
        property :url, :string, :required, 'URL'
        property :version, :string, :required
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
