class ApplicationMailer < ActionMailer::Base
  default from: Rails.configuration.x.dalphi['mailer']['default-from']
  layout 'mailer'
end
