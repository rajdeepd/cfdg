class EventNotification < ActionMailer::Base
  default from: "admin@cfdg.com"

  def rsvped_event(event,user)
    logger.info "########## rsvp event ###############"
    @user = user
    @event = event
    mail(:to => user.email, :subject => "RSVP event")
  end

  def event_cancellation(event,emails)
     @event = event
     mail(:to => emails, :subject => "Event Cancellation")
  end
end
