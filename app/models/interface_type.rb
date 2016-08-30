class InterfaceType < ApplicationRecord
  has_many :interfaces,
           dependent: :destroy

  validates :name,
    presence: true

  validate do |interface_type|
    json_string = interface_type.test_payload
    next if json_string.nil? or json_string.empty?
    JsonValidator.validate_json(interface_type, json_string)
  end
end
