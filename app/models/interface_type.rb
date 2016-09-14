class InterfaceType < ApplicationRecord
  has_many :annotation_documents
  has_many :interfaces
  has_and_belongs_to_many :services

  validates :name,
    presence: true,
    uniqueness: true

  validate do |interface_type|
    json_string = interface_type.test_payload
    next if json_string.nil? || json_string.empty?
    JsonValidator.validate_json(interface_type, json_string)
  end

  def self.destroy_abandoned
    InterfaceType.includes(:services)
                 .includes(:interfaces)
                 .includes(:annotation_documents)
                 .where(
                   services: { id: nil },
                   interfaces: { id: nil },
                   annotation_documents: { id: nil }
                 )
                 .destroy_all
  end

  def self.convert_interface_types(interface_type_names)
    interface_types = []
    return interface_types unless interface_type_names || interface_type_names.any?

    interface_type_names.each do |type_name|
      interface_types << InterfaceType.find_or_create_by(name: type_name)
    end

    interface_types
  end
end
