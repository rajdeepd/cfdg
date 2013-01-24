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
    mail(:to => @user.email, :subject => I18n.t("mail.event_mailer.rsvp_confirm.subject", :chapter_name => @event.chapter.name))
  end

  def rsvp_confirmed_mail(event_member)
    @event_member = event_member
    @user = @event_member.user
    @event = @event_member.event
    mail(:to => @user.email, :subject => I18n.t("mail.event_mailer.rsvp_confirmed.subject", :chapter_name => @event.chapter.name))
  end

  def approval_mail(event)
    @event = event
    @creator = User.find(@event.created_by) # Now there's only one event member which is the creator because the event is just approved.

    mail(:to => @creator.email, :subject => I18n.t("mail.chapter_mailer.approval.subject", :chapter_name => @event.chapter.name)) if @creator
  end

  def denial_mail(event)
    @event = event
    @creator = User.find(@event.created_by) # Now there's only one event member which is the creator because the event is just approved.

    mail(:to => @creator.email, :subject => I18n.t("mail.chapter_mailer.denial.subject", :chapter_name => @event.chapter.name)) if @creator
  end

  def new_event_notice_mail(event, receivers)
    @event = event

    mail(:bcc => receivers, :subject => I18n.t("mail.chapter_mailer.new_event_notice.subject", :chapter_name => @event.chapter.name))
  end
end
