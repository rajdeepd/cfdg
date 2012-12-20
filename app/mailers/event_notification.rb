class EventNotification < ActionMailer::Base
  default from: "from@example.com"

  def rsvped_event(event,user)
    logger.info "########## rsvp event ###############"
    @user = user
    @event = event
    mail(:to => user.email, :subject => "RSVP event")
  end
end
