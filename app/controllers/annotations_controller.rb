class AnnotationsController < ApplicationController
  before_action :authenticate_user
  before_action :set_project,
                only: [
                  :annotate
                ]
  before_action :set_annotation_document,
                only: [
                  :annotate
                ]

  # GET /projects/1/annotate/[1]
  def annotate
    if @project.annotation_documents.empty?
      flash[:alert] = I18n.t 'projects.annotate.errors.no-annotation-documents'
      render :blankslate
    end

    @container_class = Rails.configuration.x.dalphi['annotation-interface']['container-class-name']
    @auth_token = ApplicationController.generate_auth_token
  end

  private

  def set_project
    @project = Project.find(annotation_params[:project_id])
  end

  def set_annotation_document
    id = annotation_params[:annotation_document_id]
    @annotation_document = AnnotationDocument.find(id) if id
  end

  def annotation_params
    params.permit(
      :annotation_document_id,
      :project_id
    )
  end
end
