class AnnotationDocument < ApplicationRecord
  include Swagger::Blocks

  belongs_to :project
  belongs_to :raw_datum

  enum interface_type: [ :text_nominal ]
  serialize :options, Array

  before_validation do
    self.project = raw_datum.project if raw_datum
  end

  swagger_schema :AnnotationDocument do
    key :required,
        [
          :chunk_offset,
          :content,
          :options,
          :raw_data_id,
          :type
        ]

    property :chunk_offset do
      key :description, I18n.t('api.annotation_document.description.chunk_offset')
      key :type, :integer
    end

    property :content do
      key :description, I18n.t('api.annotation_document.description.content')
      key :type, :string
    end

    property :id do
      key :description, I18n.t('api.annotation_document.description.id')
      key :type, :integer
    end

    property :label do
      key :description, I18n.t('api.annotation_document.description.label')
      key :type, :string
    end

    property :options do
      key :description, I18n.t('api.annotation_document.description.options')
      key :pattern, '\[(\"[\w\ ]+\",\ )*(\"[\w\ ]+\")\]'
      key :type, :string
    end

    property :raw_data_id do
      key :description, I18n.t('api.annotation_document.description.raw_data_id')
      key :type, :integer
    end

    property :interface_type do
      key :description, I18n.t('api.annotation_document.description.interface_type')
      key :enum, ['text_nominal']
      key :type, :string
    end
  end

  validates :chunk_offset,
    presence: true,
    numericality: { greater_than_or_equal_to: 0 }

  validates :raw_datum,
    presence: true

  validates :interface_type,
    presence: true,
    inclusion: { in: self.interface_types }

  validates :options,
    presence: true

  validates :content,
    presence: true,
    uniqueness: { scope: :project }

  validate do |annotation_document|
    AnnotationDocumentValidator.validate_chunk_offset_upper_limit(annotation_document)
    AnnotationDocumentValidator.validate_options_array(annotation_document)
    # AnnotationDocumentValidator.validate_content(annotation_document)
    AnnotationDocumentValidator.validate_label(annotation_document)
  end
end
