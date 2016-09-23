class AnnotationDocumentsController < ApplicationController
  before_action :set_project,
                only: [
                  :next,
                  :index,
                  :show
                ]
  before_action :set_raw_datum,
               only: [:index]
  before_action :set_annotation_document,
                only: [:show]
  skip_before_action :authenticate_admin!,
                     only: :next if Rails.env.test?

  # GET /projects/1/annotation_documents
  # GET /projects/1/raw_data/1/annotation_documents
  def index
    annotation_documents = AnnotationDocument.where(project: @project)
    annotation_documents = annotation_documents.where(raw_datum: @raw_datum) if @raw_datum
    per_page = Rails.configuration.x.dalphi['paginated-objects-per-page']['annotation-documents']
    @annotation_documents = annotation_documents
                              .paginate(
                                page: params[:page],
                                per_page: per_page
                              )
  end

  # GET /projects/1/annotation_documents/1
  # GET /projects/1/raw_data/1/annotation_documents/1
  def show
  end


  INITIAL_DALPHI_COMMIT_DATETIME = DateTime.parse '07.03.2016 09:39:24 MEZ'

  # PATCH /projects/1/annotation_documents/next?count=10
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

    def set_raw_datum
      raw_datum_id = params[:raw_datum_id]
      @raw_datum = RawDatum.find(raw_datum_id) if raw_datum_id
    rescue
      @raw_datum = false
    end

    def set_annotation_document
      @annotation_document = AnnotationDocument.find(params[:id])
    end

    def annotation_documents(count)
      count = 1 unless count
      timeout = Rails.configuration.x.dalphi['timeouts']['annotation-document-edit-time']
      time_range = INITIAL_DALPHI_COMMIT_DATETIME..(Time.zone.now - timeout.minutes)

      AnnotationDocument.where(project: @project,
                               skipped: nil,
                               requested_at: [nil, time_range])
                        .limit(count)
    end

    def render_error_response(code, locale_key)
      render status: code,
             json: {
               message: I18n.t("annotation-documents.errors.#{locale_key}")
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
