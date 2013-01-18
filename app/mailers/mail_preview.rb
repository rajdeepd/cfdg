class MailPreview < MailView
  def confirmation_mail
    @user = User.all.first
    UserMailer.confirmation_mail(@user)
  end
end
