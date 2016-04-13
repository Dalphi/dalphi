class Project < ApplicationRecord
  belongs_to :user
  has_many :raw_data

  validates :title,
    presence: true
end
