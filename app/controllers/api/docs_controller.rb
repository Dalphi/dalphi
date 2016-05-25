module API
  class DocsController < ActionController::Base
    include Swagger::Blocks

    swagger_root do
      key :swagger, '2.0'
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
        key :description, 'This Webapp\'s service description.'
      end
      key :host, 'localhost:3000'
      key :basePath, '/api/v1'
      key :consumes, ['application/json']
      key :produces, ['application/json']
    end

    # A list of all classes that have swagger_* declarations.
    SWAGGERED_CLASSES = [
      API::V1::WhoAreYouController,
      self,
    ].freeze

    def index
      render json: Swagger::Blocks.build_root_json(SWAGGERED_CLASSES)
    end
  end
end
