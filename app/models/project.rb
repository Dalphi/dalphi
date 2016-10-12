class Project < ApplicationRecord
  belongs_to :admin
  belongs_to :iterate_service,
             class_name: 'Service',
             foreign_type: 'iterate_service'
  belongs_to :machine_learning_service,
             class_name: 'Service',
             foreign_type: 'machine_learning_service'
  belongs_to :merge_service,
             class_name: 'Service',
             foreign_type: 'merge_service'
  has_many :raw_data,
           dependent: :destroy
  has_many :statistics,
           dependent: :destroy
  has_many :annotation_documents

  has_and_belongs_to_many :interfaces

  validates :title,
    presence: true

  validate do |project|
    ProjectServiceValidator.validate_iterate_service(project)
    ProjectServiceValidator.validate_machine_learning_service(project)
    ProjectServiceValidator.validate_merge_service(project)
    ProjectInterfacesValidator.validate(project)
  end

  def associated_problem_identifiers
    problem_identifiers = []
    Service.roles.keys.each do |role|
      service = self.send("#{role}_service")
      problem_identifiers << service.problem_id if service
    end
    problem_identifiers.uniq.sort
  end

  def iterate_data
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

  def merge_data
    data = []
    self.annotation_documents.group_by(&:raw_datum).each do |raw_datum, annotation_documents|
      data << {
        corpus_document: {
          raw_datum_id: raw_datum.id,
          content: Base64.encode64(
                     File.new(raw_datum.data.path).read
                   )
        },
        annotation_documents: annotation_documents
      }
    end
    data
  end

  def update_merged_raw_datum(params)
    raw_datum = self.raw_data.find(params['raw_datum_id'])
    File.open(raw_datum.data.path, 'w') do |file|
      file.write(Base64.decode64(params['content']).force_encoding('utf-8'))
    end
  rescue
    nil
  end

  def label
    self.title
  end

  def selected_interfaces
    selected_interfaces = {}
    self.necessary_interface_types.each do |interface_type|
      interface = self.interfaces.find_by(interface_type: interface_type)
      selected_interfaces[interface_type.name] = interface.title rescue nil
    end
    selected_interfaces
  end

  def necessary_interface_types
    return iterate_service.interface_types if iterate_service
    []
  end

  def connect_services
    services = Service.all
    Service.roles.keys.each do |role|
      role_services = services.where(role: role)
      self.send("#{role}_service=", role_services.first) if role_services.length == 1
    end
  end

  def zip(file)
    Zip::OutputStream.open(file) { |zos| }
    Zip::File.open(file.path, Zip::File::CREATE) do |zipfile|
      self.raw_data.each do |raw_datum|
        zipfile.add(raw_datum.filename, raw_datum.data.path)
      end
    end
    return File.read(file)
  end
end
