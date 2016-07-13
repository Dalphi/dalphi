class AnnotationDocumentValidator < ActiveModel::Validator

  def initialize(_model)
  end

  def self.validate_requested_at(record)
    return if record.requested_at.nil?

    if record.requested_at > Time.zone.now
      error_message = I18n.t('activerecord.errors.models.annotation_document' \
                             '.attributes.requested_at.is-in-future')
      record.errors[:requested_at] << error_message
    end
  end
end
