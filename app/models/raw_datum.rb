class RawDatum < ApplicationRecord
  SHAPES = %w(text)

  belongs_to :project

  validates :shape,
    presence: true

  has_attached_file :data
  validates_attachment_content_type :data, content_type: [/.*/]
end
