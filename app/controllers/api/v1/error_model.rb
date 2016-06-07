module API
  module V1
    class ErrorModel
      include Swagger::Blocks

      swagger_schema :ErrorModel do
        key :required, [:message]

        property :message do
          key :description, 'description of what went wrong'
          key :type, :string
        end

        property :validationErrors do
          key :description, 'list of model validation errors'
          key :type, :string
        end
      end
    end
  end
end
