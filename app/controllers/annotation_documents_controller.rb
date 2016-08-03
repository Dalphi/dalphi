class AnnotationDocumentsController < ApplicationController
  before_action :set_project, only: [ :next ]
  skip_before_action :authenticate_user!, only: :next if Rails.env.test?

  # PATCH /projects/1/annotation_documents/next/10
  def next
    documents = annotation_documents(annotation_document_params['count'])

    if documents.count == 0
      render_error_response 404, 'next.no-documents'

    elsif documents.update(requested_at: Time.zone.now)
      render json: documents.map{ |document| document.relevant_attributes }

    else
      render_error_response 500, 'next.update-failed'
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_project
      @project = Project.find(params[:project_id])
    rescue
      render_error_response 400, 'set-project.not-found'
    end

    def annotation_documents(count)
      count = 1 unless count
      initial_dalphi_commit_datetime = DateTime.parse '07.03.2016 09:39:24 MEZ'
      timeout = Rails.configuration.x.dalphi['timeouts']['annotation-document-edit-time']
      time_range = initial_dalphi_commit_datetime..(Time.zone.now - timeout.minutes)

      AnnotationDocument.where(project: @project,
                               skipped: [nil, false],
                               requested_at: [nil, time_range])
                        .limit(count)
    end

    def render_error_response(code, locale_key)
      render status: code,
             json: {
               message: I18n.t("annotation_documents.errors.#{locale_key}")
             }
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def annotation_document_params
      params.permit(
        :count,
        :project_id
      )
    end
end
