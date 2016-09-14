module API
  module V1
    class AnnotationDocumentsController < BaseController
      include Swagger::Blocks

      before_action :set_annotation_document,
                    only: [
                      :show,
                      :update,
                      :destroy
                    ]

      swagger_path '/annotation_documents/{id}' do
        operation :get do
          key :comsumes, ['application/json']
          key :description, I18n.t('api.annotation_document.show.description')
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
            key :description, I18n.t('api.annotation_document.show.response-200')
            schema do
              key :'$ref', :AnnotationDocument
            end
          end

          response 400 do
            key :description, I18n.t('api.annotation_document.show.response-400')
            schema do
              key :'$ref', :ErrorModel
            end
          end
        end
      end

      swagger_path '/annotation_documents' do
        operation :post do
          key :comsumes, ['application/json']
          key :description, I18n.t('api.annotation_document.create.description')
          key :operationId, 'annotation_document_create'
          key :produces, ['application/json']
          key :tags, ['AnnotationDocuments']

          parameter name: :json_object do
            key :in, :body
            key :required, true
            schema do
              key :'$ref', :AnnotationDocument
            end
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

      swagger_path '/annotation_documents/{id}' do
        operation :patch do
          key :comsumes, ['application/json']
          key :description, I18n.t('api.annotation_document.update.description')
          key :operationId, 'annotation_document_update'
          key :produces, ['application/json']
          key :tags, ['AnnotationDocuments']

          parameter name: :id do
            key :in, :path
            key :required, true
            key :type, :integer
            key :format, :int32
          end

          parameter name: :json_object do
            key :in, :body
            key :required, true
            schema do
              key :'$ref', :AnnotationDocument
            end
          end

          response 200 do
            key :description, I18n.t('api.annotation_document.update.response-200')
            schema do
              key :'$ref', :AnnotationDocument
            end
          end

          response 400 do
            key :description, I18n.t('api.annotation_document.update.response-400')
            schema do
              key :'$ref', :ErrorModel
            end
          end
        end
      end

      swagger_path '/annotation_documents/{id}' do
        operation :delete do
          key :comsumes, ['application/json']
          key :description, I18n.t('api.annotation_document.destroy.description')
          key :operationId, 'annotation_document_destroy'
          key :produces, ['application/json']
          key :tags, ['AnnotationDocuments']

          parameter name: :id do
            key :in, :path
            key :required, true
            key :type, :integer
            key :format, :int32
          end

          response 200 do
            key :description, I18n.t('api.annotation_document.destroy.response-200')
            schema do
              key :'$ref', :AnnotationDocument
            end
          end

          response 400 do
            key :description, I18n.t('api.annotation_document.destroy.response-400')
            schema do
              key :'$ref', :ErrorModel
            end
          end
        end
      end

      # POST /api/v1/annotation_documents
      def create
        @annotation_document = AnnotationDocument.new(annotation_document_params)

        if @annotation_document.save
          render status: 200,
                 json: @annotation_document.relevant_attributes
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

      # GET /api/v1/annotation_documents/1
      def show
        render json: @annotation_document.relevant_attributes
      end

      # PATCH/PUT /api/v1/annotation_documents/1
      def update
        if @annotation_document.update(annotation_document_params)
          render json: @annotation_document.relevant_attributes
        else
          render status: 400,
                 json: {
                   message: I18n.t('api.annotation_document.update.error'),
                   validationErrors: @annotation_document.errors.full_messages
                 }
        end
      rescue ArgumentError
        return_parameter_type_mismatch
      end

      # DELETE /api/v1/annotation_documents/1
      def destroy
        @annotation_document.destroy
        render status: 200,
               json: @annotation_document.relevant_attributes
      end

      private

        def set_annotation_document
          @annotation_document = AnnotationDocument.find(params[:id])
        rescue
          render status: 400,
                 json: {
                   message: I18n.t('api.annotation_document.show.error')
                 }
        end

        def return_parameter_type_mismatch
          render status: 400,
                 json: {
                   message: I18n.t('api.annotation_document.general-errors.parameter-type-mismatch')
                 }
        end

        def annotation_document_params
          params_annotation_document = params[:annotation_document]
          parameters = params.require(:annotation_document).permit(
            :id,
            :interface_type,
            :payload,
            :rank,
            :raw_datum_id,
            :skipped
          )
          parameters[:payload] = params_annotation_document[:payload].to_json
          parameters[:interface_type] = InterfaceType.find_or_create_by(
                                          name: params_annotation_document[:interface_type]
                                        )
          parameters
        end
    end
  end
end
