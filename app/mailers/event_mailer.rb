class EventMailer < ActionMailer::Base
  layout 'mail_default'
  default :from => "contact.cfdg@gmail.com"

  def new_event_mail(event)
    @event = event 
    @admin = User.admin_user 

    mail(:to => @admin.email, :subject => I18n.t("mail.event_mailer.new_event.subject"))
  end
end
