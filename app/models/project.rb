class Project < ApplicationRecord
  belongs_to :user
  has_many :raw_data, dependent: :destroy

  validates :title,
    presence: true

  validate do |project|
    ProjectServiceValidator.validate_active_learning_service(project)
    ProjectServiceValidator.validate_bootstrap_service(project)
    ProjectServiceValidator.validate_machine_learning_service(project)
  end
end
