class RawDatum < ApplicationRecord
  SHAPES = %w(text)

  belongs_to :project
  has_attached_file :data

  validates :shape,
    presence: true,
    inclusion: { in: SHAPES }

  validates :data,
    attachment_presence: true

  validates_attachment :data,
    content_type: {
      content_type: ['text/plain', 'text/markdown', 'text/html', 'text/rtf']
    }
end
