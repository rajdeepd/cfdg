class EventNotification < ActionMailer::Base
  default from: "admin@cfdg.com"

  def rsvped_event(event,user)
    logger.info "########## rsvp event ###############"
    @user = user
    @event = event
    mail(:to => user.email, :subject => "R.S.V.P event")
  end

  def event_cancellation(event,emails)
     @event = event
     mail(:to => emails, :subject => "Event Cancellation")
  end

  def event_creation(event,emails,chapter)
    @event = event
    @chapter = chapter
    mail(:to => emails, :subject => "New Event")
  end

  def event_edit(event,emails,chapter)
    @event = event
    @chapter = chapter
    mail(:to => emails, :subject => "Event Updated")
  end

end
