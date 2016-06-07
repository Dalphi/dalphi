module API
  module V1
    class AnnotationDocumentsController < BaseController
      include Swagger::Blocks

      before_action :set_annotation_document, only: [:get, :update, :destroy]

      swagger_path '/annotation_documents' do
        operation :get do
          key :comsumes, ['application/json']
          key :description, 'Returns an annotation document'
          key :operationId, 'annotation_document_read'
          key :produces, ['application/json']
          key :tags, ['AnnotationDocuments']

          parameter name: :id do
            key :in, :path
            key :required, true
            key :type, :integer
            key :format, :int32
          end

          response 200 do
            key :description, I18n.t('api.annotation_document.get.response-200')
            schema do
              key :'$ref', :AnnotationDocument
            end
          end

          response 400 do
            key :description, I18n.t('api.annotation_document.get.response-400')
            schema do
              key :'$ref', :ErrorModel
            end
          end
        end

        operation :post do
          key :comsumes, ['application/json']
          key :description, 'Creates a new annotation document'
          key :operationId, 'annotation_document_create'
          key :produces, ['application/json']
          key :tags, ['AnnotationDocuments']

          parameter name: :chunk_offset do
            key :in, :formData
            key :required, true
            key :type, :integer
            key :format, :int32
          end

          parameter name: :content do
            key :in, :formData
            key :required, true
            key :type, :string
          end

          parameter name: :label do
            key :in, :formData
            key :maxLength, 255
            key :required, false
            key :type, :string
          end

          parameter name: :options do
            key :in, :formData
            key :minItems, 2
            key :required, true
            key :type, :array
            key :uniqueItems, true
            items do
              key :maxLength, 255
              key :type, :string
            end
          end

          parameter name: :raw_data_id do
            key :in, :formData
            key :required, true
            key :type, :integer
            key :format, :int32
          end

          parameter name: :type do
            key :in, :formData
            key :maxLength, 255
            key :required, true
            key :type, :string
          end

          response 200 do
            key :description, I18n.t('api.annotation_document.create.response-200')
            schema do
              key :'$ref', :AnnotationDocument
            end
          end

          response 400 do
            key :description, I18n.t('api.annotation_document.create.response-400')
            schema do
              key :'$ref', :ErrorModel
            end
          end
        end
      end

      def create
        ap 'CREATE:'
        ap annotation_document_params
        @annotation_document = AnnotationDocument.new(annotation_document_params)
        if @annotation_document.save
          render json: @annotation_document
        else
          render status: 400,
                 json: {
                   message: I18n.t('api.annotation_document.create.error'),
                   validationErrors: @annotation_document.errors.full_messages
                 }
        end
      rescue ArgumentError
        return_parameter_type_mismatch
      end

      def get
        if @annotation_document
          render json: @annotation_document
        else
          render status: 400,
                 json: {
                   message: I18n.t('api.annotation_document.get.error')
                 }
        end
      end

      private

        def set_annotation_document
          @annotation_document = AnnotationDocument.find(params[:id])
        end

        def return_parameter_type_mismatch
          render status: 400,
                 json: {
                   message: I18n.t('api.annotation_document.general-errors.parameter-type-mismatch')
                 }
        end

        def annotation_document_params
          params.permit(
            :chunk_offset,
            :content,
            :label,
            :options,
            :raw_data_id,
            :type
          )
        end
    end
  end
end
