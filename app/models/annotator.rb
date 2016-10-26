class Annotator < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  has_many :annotation_documents, as: :annotable

  has_and_belongs_to_many :projects,
                          after_add: :assign_to_project,
                          after_remove: :unassign_from_project

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
