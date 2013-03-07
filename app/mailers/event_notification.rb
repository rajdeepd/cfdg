class EventNotification < ActionMailer::Base
  default from: "contact.cfdg@gmail.com"

  def rsvped_event(event,user)

    @user = user
    @event = event
    mail(:to => user.email, :subject => "R.S.V.P event")
  end

  def user_registration_for_event(event,user)
      @user = user
      @event = event
      mail(:to => user.email, :subject => "Thank You for attending the CFDG event.")
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

  def event_invitation(user,event,chapter)
    @user = user
    @event = event
    @chapter = chapter
  end
end
