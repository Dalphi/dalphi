module API
  class DocsController < ActionController::Base
    include Swagger::Blocks

    swagger_root do
      key :swagger, '2.0'
      key :host, "#{ENV['DOMAIN']}#{":#{ENV['PORT']}" if ENV['PORT'] != ''}"
      key :basePath, '/api/v1'
      key :consumes, ['application/json']
      key :produces, ['application/json']

      info do
        key :version, '1'
        key :title, 'Dalphi'
        key :description, 'Dalphi Active Learning Platform for Human Interaction'
        key :termsOfService, 'https://github.com/Dalphi/dalphi/blob/master/README.md'

        contact do
          key :name, 'Implisense GmbH, 3antworten UG (haftungsbeschränkt)'
        end

        license do
          key :name, 'Apache 2.0'
        end
      end

      tag do
        key :name, 'WhoAreYou'
        key :description, 'Identifies the service that is operating at this URL'
      end

      tag do
        key :name, 'AnnotationDocuments'
        key :description, 'Listing all interactions with annotation documents'
      end
    end

    SWAGGERED_CLASSES = [
      API::V1::AnnotationDocumentsController,
      API::V1::WhoAreYouController,
      API::V1::ErrorModel,
      AnnotationDocument,
      Service,
      self,
    ].freeze

    def index
      render json: Swagger::Blocks.build_root_json(SWAGGERED_CLASSES)
    end
  end
end
