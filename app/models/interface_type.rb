class InterfaceType < ApplicationRecord
  has_many :interfaces,
           dependent: :destroy
  has_and_belongs_to_many :services

  validates :name,
    presence: true

  validate do |interface_type|
    json_string = interface_type.test_payload
    next if json_string.nil? or json_string.empty?
    JsonValidator.validate_json(interface_type, json_string)
  end
end
