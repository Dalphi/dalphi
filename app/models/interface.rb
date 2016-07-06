class Interface < ApplicationRecord
  has_and_belongs_to_many :projects

  serialize :associated_problem_identifiers, Array

  validates :interface_type, :associated_problem_identifiers,
    presence: true

  validates :title, :template,
    presence: true,
    uniqueness: true

  validate do |interface|
    WebsiteComponentsValidator.validate_stylesheet(interface)
    WebsiteComponentsValidator.validate_java_script(interface)
  end
end
