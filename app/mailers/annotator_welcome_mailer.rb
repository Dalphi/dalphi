class AnnotatorWelcomeMailer < ApplicationMailer
  def with_password(annotator)
    @annotator = annotator
    mail to: @annotator.email,
         subject: t('mailers.annotator-welcome.with-password.subject',
                    annotator: @annotator.name)
  end

  def without_password(annotator)
    @annotator = annotator
    mail to: @annotator.email,
         subject: t('mailers.annotator-welcome.without-password.subject',
                    annotator: @annotator.name)
  end
end
