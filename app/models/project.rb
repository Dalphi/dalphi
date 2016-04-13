class Project < ApplicationRecord
  belongs_to :user
  has_many :raw_data, dependent: :destroy

  validates :title,
    presence: true
end
