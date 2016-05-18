class Project < ApplicationRecord
  belongs_to :user
  belongs_to :active_learning_service,
             class_name: 'Service',
             foreign_type: 'active_learning_service_id'
  belongs_to :bootstrap_service,
             class_name: 'Service',
             foreign_type: 'bootstrap_service'
  belongs_to :machine_learning_service,
             class_name: 'Service',
             foreign_type: 'machine_learning_service'
  has_many :raw_data,
           dependent: :destroy

  validates :title,
    presence: true

  validate do |project|
    ProjectServiceValidator.validate_active_learning_service(project)
    ProjectServiceValidator.validate_bootstrap_service(project)
    ProjectServiceValidator.validate_machine_learning_service(project)
  end
end
