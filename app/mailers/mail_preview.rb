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

  def newly_created_mail
    @chapter = Chapter.all.first
    @user = User.all.first
    ChapterMailer.newly_created_mail(@chapter, @user)
  end

  def new_event_mail
    @event = Event.all.first
    EventMailer.new_event_mail(@event)
  end
end
