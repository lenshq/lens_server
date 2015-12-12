class ApplicationMailer < ActionMailer::Base
  default from: LensServer.config.mailer.from

  layout 'mailer'
end
