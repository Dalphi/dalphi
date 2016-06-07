module API
  module V1
    class AnnotationDocumentsController < BaseController
      include Swagger::Blocks

      swagger_path '/annotation_documents' do
        operation :post do
          key :comsumes, ['application/json']
          key :description, 'Creates a new annotation document'
          key :operationId, 'annotation_document_create'
          key :produces, ['application/json']
          key :tags, ['AnnotationDocuments']

          parameter name: :chunk_offset do
            key :required, true
            key :type, :integer
          end

          parameter name: :options do
            key :minItems, 2
            key :required, true
            key :type, :array
            key :uniqueItems, true
            items do
              key :type, :string
            end
          end

          response 200 do
            key :description, 'annotation document response'
            schema do
              key :'$ref', :AnnotationDocument
            end
          end
        end
      end

      def create
        # TODO
        # @project = AnnotationDocument.new(params_with_service_instances)
        # @project.user = current_user
        # if @project.save
        #   redirect_to project_raw_data_path(@project), notice: I18n.t('projects.action.create.success')
        # else
        #   flash[:error] = I18n.t('simple_form.error_notification.default_message')
        #   render :new
        # end

        render json: { status: 'okay' }
      end
    end
  end
end
