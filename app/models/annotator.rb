class Annotator < ApplicationRecord
  # available devise modules:
  # :confirmable, :lockable, :timeoutable, :omniauthable, :registerable

  devise :database_authenticatable, :recoverable, :rememberable,
         :trackable, :validatable

  has_many :annotation_documents, as: :annotable

  has_and_belongs_to_many :projects,
                          after_add: :assign_to_project,
                          after_remove: :unassign_from_project

  before_validation(on: :create) do |annotator|
    unless annotator.encrypted_password.present?
      annotator.password = SecureRandom.hex
      @without_password = true
    end
  end

  after_commit(on: :create) do |annotator|
    if @without_password
      AnnotatorWelcomeMailer.without_password(annotator).deliver_later
    else
      AnnotatorWelcomeMailer.with_password(annotator).deliver_later
    end
  end

  validates :name,
            presence: true

  def assign_to_project(project)
    AnnotatorProjectAssignmentMailer.assign(self, project).deliver_later
  end

  def unassign_from_project(project)
    AnnotatorProjectAssignmentMailer.unassign(self, project).deliver_later
  end

  def label
    name
  end
end
