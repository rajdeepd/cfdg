class EventMailer < ActionMailer::Base
  layout 'mail_default'
  default :from => "contact.cfdg@gmail.com"

  def new_event_mail(event)
    @event = event 
    @admin = User.admin_user 

    mail(:to => @admin.email, :subject => I18n.t("mail.event_mailer.new_event.subject"))
  end

  def rsvp_confirm_mail(event_member)
    @event_member = event_member
    @user = @event_member.user
    @event = @event_member.event
    mail(:to => @user.email, :subject => I18n.t("mail.event_mailer.rsvped_confirm.subject", :chapter_name => @event.chapter.name))
  end
end
