class MailPreview < MailView
  def confirmation_mail
    @user = User.all.first
    UserMailer.confirmation_mail(@user)
  end

  def welcome_mail
    @user = User.all.first
    UserMailer.welcome_mail(@user)
  end

  def new_chapter_mail
    @chapter = Chapter.all.first
    ChapterMailer.new_chapter_mail(@chapter)
  end

  def approval_mail
    @chapter = Chapter.all.first
    ChapterMailer.approval_mail(@chapter)
  end

  def denial_mail
    @chapter = Chapter.all.first
    ChapterMailer.denial_mail(@chapter)
  end

  def newly_created_chapter_mail
    @chapter = Chapter.all.first
    @receivers = ["thehiddendepth@gmail.com", "larry.zhao@outlook.com"]
    ChapterMailer.newly_created_mail(@chapter, @receivers)
  end

  def new_event_mail
    @event = Event.all.first
    EventMailer.new_event_mail(@event)
  end

  def rsvp_confirm_mail
    @event_member = EventMember.all.first
    EventMailer.rsvp_confirm_mail(@event_member)
  end

  def rsvp_confirmed_mail
    @event_member = EventMember.all.first
    EventMailer.rsvp_confirmed_mail(@event_member)
  end

  def event_approval_mail
    @event = Event.all.first
    EventMailer.approval_mail(@event)
  end

  def event_denial_mail
    @event = Event.all.first
    EventMailer.denial_mail(@event)
  end

  def new_event_notice_mail
    @event = Event.all.first
    @receivers = ["thehiddendepth@gmail.com", "larry.zhao@outlook.com"]
    EventMailer.new_event_notice_mail(@event, @receivers)
  end

  def admin_event_cancelled_mail
    @event = Event.all.first
    EventMailer.admin_event_cancelled_mail(@event)
  end

  def admin_event_changed_mail
    @event = Event.all.first

    EventMailer.admin_event_changed_mail(@event)
  end

  def event_cancelled_notice_mail
    @event = Event.all.first
    @receivers = ["thehiddendepth@gmail.com", "larry.zhao@outlook.com"]
    EventMailer.event_cancelled_notice_mail(@event, @receivers)
  end

  def event_changed_notice_mail
    @event = Event.all.first
    @receivers = ["thehiddendepth@gmail.com", "larry.zhao@outlook.com"]
    EventMailer.event_changed_notice_mail(@event, @receivers)
  end
end
