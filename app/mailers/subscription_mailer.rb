class SubscriptionMailer < ApplicationMailer
  def welcome_email
    mail(to: 'me@zzet.org', subject: 'Welcome to My Awesome Site')
  end
end
