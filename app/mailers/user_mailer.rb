class UserMailer < ActionMailer::Base
  default :from => "contact.cfdg@gmail.com"

  def welcome_mail(user)
    @user = user
    mail(:to => @user.email, :subject => "Welcome mail")
  end

  def confirmation_mail(user)
    @user = user

    mail(:to => @user.email, :subject => I18n.t("mail.subjects.confirmation")) do |format|
      format.html { render :layout => 'mail_default' }
    end
  end
end
