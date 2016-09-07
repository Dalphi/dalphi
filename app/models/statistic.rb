class Statistic < ApplicationRecord
  belongs_to :project

  validates :key,
            presence: true

  validates_uniqueness_of :key,
                          scope: :iteration_index
end
