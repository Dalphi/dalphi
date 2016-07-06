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

  has_and_belongs_to_many :interfaces

  validates :title,
    presence: true

  validate do |project|
    ProjectServiceValidator.validate_active_learning_service(project)
    ProjectServiceValidator.validate_bootstrap_service(project)
    ProjectServiceValidator.validate_machine_learning_service(project)
    ProjectServiceValidator.validate_merge_service(project)
  end

  def associated_problem_identifiers
    problem_identifiers = []
    Service.roles.keys.each do |role|
      service = self.send("#{role}_service")
      problem_identifiers << service.problem_id if service
    end
    problem_identifiers.uniq.sort
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

  def connect_services
    services = Service.all
    Service.roles.keys.each do |role|
      role_services = services.where(role: role)
      self.send("#{role}_service=", role_services.first) if role_services.length == 1
    end
  end
end
