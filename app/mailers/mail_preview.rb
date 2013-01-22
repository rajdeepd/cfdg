class MailPreview < MailView
  def confirmation_mail
    @user = User.all.first
    UserMailer.confirmation_mail(@user)
  end

  def welcome_mail
    @user = User.all.first
    UserMailer.welcome_mail(@user)
  end
end
