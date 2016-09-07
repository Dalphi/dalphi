class Statistic < ApplicationRecord
  validates :key,
            presence: true

  validates_uniqueness_of :key,
                          scope: :iteration_index
end
