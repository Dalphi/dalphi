class AnnotatorProjectAssignmentMailer < ApplicationMailer
  def assign(annotator, project)
    @annotator = annotator
    @project = project
    mail to: @annotator.email,
         subject: t('mailers.annotator-project-assignment.assign.subject')
  end

  def unassign(annotator, project)
    @annotator = annotator
    @project = project
    mail to: @annotator,
         subject: t('mailers.annotator-project-assignment.unassign.subject')
  end
end
