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
  belongs_to :merge_service,
             class_name: 'Service',
             foreign_type: 'merge_service'
  has_many :raw_data,
           dependent: :destroy
  has_many :annotation_documents

  validates :title,
    presence: true

  validate do |project|
    ProjectServiceValidator.validate_active_learning_service(project)
    ProjectServiceValidator.validate_bootstrap_service(project)
    ProjectServiceValidator.validate_machine_learning_service(project)
    ProjectServiceValidator.validate_merge_service(project)
  end

  def bootstrap_data
    data = []
    self.raw_data.each do |raw_datum|
      data << {
        raw_datum_id: raw_datum.id,
        content: Base64.encode64(
                   File.new(raw_datum.data.path).read
                 )
      }
    end
    data
  end

  def label
    self.title
  end
end
