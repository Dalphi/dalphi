class RawDatum < ApplicationRecord
  SHAPES = %w(text)

  belongs_to :project

  validates :shape,
    presence: true
end
