class EventNotification < ActionMailer::Base
  default from: "admin@cfdg.com"

  def rsvped_event(event,user)
    logger.info "########## rsvp event ###############"
    @user = user
    @event = event
    mail(:to => user.email, :subject => "R.S.V.P event")
  end

  def event_cancellation(event,to,bcc)
     @event = event
     mail(:to => to,:bcc => bcc, :subject => "Event Cancellation")
  end

  def event_creation(event,to,bcc,chapter)
    @event = event
    @chapter = chapter
    mail(:to => to,:bcc=>bcc, :subject => "New Event")
  end

  def event_edit(event,to,bcc,chapter)
    @event = event
    @chapter = chapter
    mail(:to => to,:bcc => bcc, :subject => "Event Updated")
  end

end
