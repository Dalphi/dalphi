module API
  module V1
    class AnnotationDocumentsController < BaseController
      include Swagger::Blocks

      swagger_path '/annotation_documents' do
        operation :post do
          key :description, 'Creates a new annotation document'
          key :operationId, 'annotation_document_create'
          key :produces, [
            'application/json'
          ]
          key :comsumes, [
            'application/json'
          ]
          key :tags, [
            'AnnotationDocuments'
          ]
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
