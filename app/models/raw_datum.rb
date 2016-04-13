class RawDatum < ApplicationRecord
  belongs_to :project

  validates :shape,
    presence: true
end
