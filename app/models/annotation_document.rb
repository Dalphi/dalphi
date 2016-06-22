class AnnotationDocument < ApplicationRecord
  include Swagger::Blocks

  belongs_to :project
  belongs_to :raw_datum

  enum interface_type: [ :text_nominal ]

  before_validation do
    self.project = raw_datum.project if raw_datum
  end

  swagger_schema :AnnotationDocument do
    key :required,
        [
          :interface_type,
          :payload,
          :raw_datum_id
        ]

    property :id do
      key :description, I18n.t('api.annotation_document.description.id')
      key :type, :integer
    end

    property :rank do
      key :description, I18n.t('api.annotation_document.description.rank')
      key :type, :integer
    end

    property :raw_datum_id do
      key :description, I18n.t('api.annotation_document.description.raw_datum_id')
      key :type, :integer
    end

    property :payload do
      key :description, I18n.t('api.annotation_document.description.payload')
      key :example, '{"label":"testlabel","options":["option1","option2"],"content":"testcontent"}'
      key :type, :string
    end

    property :skipped do
      key :description, I18n.t('api.annotation_document.description.skipped')
      key :type, :boolean
    end

    property :interface_type do
      key :description, I18n.t('api.annotation_document.description.interface_type')
      key :enum, ['text_nominal']
      key :type, :string
    end
  end

  validates :raw_datum,
    presence: true

  validates :interface_type,
    presence: true,
    inclusion: { in: self.interface_types }

  validates :payload,
    presence: true,
    uniqueness: { scope: :project }

  validates :rank,
    allow_nil: true,
    numericality: {
      only_integer: true,
      greater_than_or_equal_to: 0
    }

  def relevant_attributes
    {
      id: id,
      interface_type: interface_type,
      payload: Base64.encode64(payload),
      rank: rank,
      raw_datum_id: raw_datum_id,
      skipped: skipped
    }
  end
end
