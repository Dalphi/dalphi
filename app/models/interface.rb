class Interface < ApplicationRecord
  has_and_belongs_to_many :projects

  before_save :compile_stylesheet
  before_save :compile_java_script

  has_attached_file :java_script
  has_attached_file :stylesheet
  has_attached_file :template

  serialize :associated_problem_identifiers, Array

  validates :interface_type, :associated_problem_identifiers,
    presence: true

  validates :title,
    presence: true

  validates_attachment_content_type :java_script,
                                    content_type: /(text\/.*|inode\/x-empty)/

  validates_attachment_content_type :stylesheet,
                                    content_type: /(text\/.*|inode\/x-empty)/

  validates_attachment_content_type :template,
                                    content_type: /(text\/.*|inode\/x-empty)/

  validate do |interface|
    WebsiteComponentsValidator.validate_stylesheet(interface)
    WebsiteComponentsValidator.validate_java_script(interface)
    InterfaceTitleUniquenessValidator.validate_title_uniqueness(interface)
  end

  @validator_compiled_stylesheet = nil
  @validator_compiled_java_script = nil

  def set_validator_compiled_stylesheet=(val)
    @validator_compiled_stylesheet = val
  end

  def set_validator_compiled_java_script=(val)
    @validator_compiled_java_script = val
  end

  def label
    self.title
  end

  private

    def compile_stylesheet
      if self.stylesheet
        self.compiled_stylesheet = @validator_compiled_stylesheet
      else
        self.compiled_stylesheet = nil
      end
    end

    def compile_java_script
      if self.java_script
        self.compiled_java_script = @validator_compiled_java_script
      else
        self.compiled_java_script = nil
      end
    end
end
