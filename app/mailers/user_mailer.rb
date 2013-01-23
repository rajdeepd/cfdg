class UserMailer < ActionMailer::Base
  default :from => "contact.cfdg@gmail.com"

  def welcome_mail(user)
    @user = user
    mail(:to => @user.email, :subject => I18n.t("mail.user_mailer.welcome.subject")) do |format|
      format.html { render :layout => 'mail_default' }
    end
  end

  def confirmation_mail(user)
    @user = user

    mail(:to => @user.email, :subject => I18n.t("mail.user_mailer.confirmation.subject")) do |format|
      format.html { render :layout => 'mail_default' }
    end
  end
end
