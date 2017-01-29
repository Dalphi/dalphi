module API
  module V1
    class AnnotationDocumentsController < BaseController
      include Swagger::Blocks
      include ErrorResponse

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
              key :type, :array
              items do
                key :'$ref', :AnnotationDocument
              end
            end
          end

          response 200 do
            key :description, I18n.t('api.annotation_document.create.response-200')
            schema do
              key :type, :array
              items do
                key :'$ref', :AnnotationDocument
              end
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
        ActiveRecord::Base.transaction do
          annotation_documents = []
          annotation_documents_params.each do |ad_params|
            @annotation_document = AnnotationDocument.new(ad_params)
            @annotation_document.save!
            annotation_documents << @annotation_document.relevant_attributes
          end
          annotation_documents = annotation_documents.first if annotation_documents.count == 1
          render status: 200,
                 json: annotation_documents
        end
      rescue ArgumentError
        return_parameter_type_mismatch
      rescue
        render status: 400,
               json: {
                 message: I18n.t('api.annotation_document.create.error')
               }
      end

      # GET /api/v1/annotation_documents/1
      def show
        if @annotation_document.update(requested_at: Time.zone.now)
          render json: @annotation_document.relevant_attributes
        else
          render_annotation_document_errors 500, 'next.update-failed'
        end
      end

      # PATCH/PUT /api/v1/annotation_documents/1
      def update
        if @annotation_document.update(converted_annotation_document_params)
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

        def annotation_documents_params
          converted_params = []
          params_annotation_documents = params[:annotation_documents]
          if params_annotation_documents.present?
            params_annotation_documents.each do |annotation_document|
              converted_params << converted_annotation_document_params(annotation_document).permit!
            end
          else
            converted_params << converted_annotation_document_params
          end
          converted_params
        end

        def annotation_document_params_from_json
          JSON.parse(params['_json'])['annotation_document']
        end

        def annotation_document_params
          return annotation_document_params_from_json if params['_json']
          parameters = params.require(:annotation_document).permit(
            :id,
            :interface_type,
            :payload,
            :rank,
            :raw_datum_id,
            :skipped,
            :meta
          )
          params_annotation_document = params[:annotation_document]
          parameters[:payload] = params_annotation_document[:payload]
          parameters[:meta] = params_annotation_document[:meta]
          parameters
        end

        # this method smells of :reek:FeatureEnvy
        def converted_annotation_document_params(annotation_document = nil)
          annotation_document ||= annotation_document_params
          payload = annotation_document['payload']
          payload.permit! unless payload.class == Hash
          meta = annotation_document['meta']
          meta.permit! if meta && meta.class != Hash
          annotation_document['interface_type'] = InterfaceType.find_or_create_by(
                                                    name: annotation_document['interface_type']
                                                  )
          annotation_document['updated_at'] = Time.zone.now
          annotation_document
        end
    end
  end
end
