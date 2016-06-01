class AnnotationDocument < ApplicationRecord
  belongs_to :project
  belongs_to :raw_datum
  has_attached_file :content

  enum type: [ :text_nominal ]
  serialize :options, Array

  before_validation do
    self.project = raw_datum.project if raw_datum
  end

  validates :chunk_offset,
    presence: true,
    numericality: { greater_than_or_equal_to: 0 }

  validates :raw_datum,
    presence: true

  validates :type,
    presence: true,
    inclusion: { in: self.types }

  validates :options,
    presence: true

  validates :content_file_name,
    uniqueness: { scope: :project }

  validates :content,
    attachment_presence: true

  validates_attachment :content,
    content_type: {
      content_type: RawDatum::MIME_TYPES_LIST
    }

  validate do |annotation_document|
    AnnotationDocumentValidator.validate_chunk_offset_upper_limit(annotation_document)
    AnnotationDocumentValidator.validate_options_array(annotation_document)
    AnnotationDocumentValidator.validate_content(annotation_document)
    AnnotationDocumentValidator.validate_label(annotation_document)
  end
end
