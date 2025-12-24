class ApplicationMailer < ActionMailer::Base
  default from: ENV.fetch('MAILER_FROM', 'noreply@ecommerce.com')
  layout 'mailer'
end
