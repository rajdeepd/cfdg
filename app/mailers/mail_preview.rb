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
end
