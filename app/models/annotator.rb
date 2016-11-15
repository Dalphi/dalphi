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
    unless annotator.encrypted_password?
      annotator.password = SecureRandom.hex
      raw, enc = Devise.token_generator.generate(annotator.class, :reset_password_token)
      @reset_password_token = raw
      annotator.reset_password_token = enc
      annotator.reset_password_sent_at = Time.zone.now
    end
  end

  after_commit(on: :create) do |annotator|
    if @reset_password_token
      AnnotatorWelcomeMailer.without_password(annotator, @reset_password_token).deliver_later
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
