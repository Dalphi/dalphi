module ErrorResponse
  extend ActiveSupport::Concern

  def render_annotation_document_errors(code, locale_key)
    render status: code,
           json: {
             message: I18n.t("annotation-documents.errors.#{locale_key}")
           }
  end
end
