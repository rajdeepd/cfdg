class UserMailer < ActionMailer::Base
  default :from => "contact.cfdg@gmail.com"

  def welcome_mail(user)
    #logger.info "########## inside welcome mail method ###############"
    #logger.info "##########this is the tester mailer ###############"
    @user = user
    mail(:to => @user.email, :subject => "Welcome mail")
  end

  def confirmation_mail(user)
    @user = user
    mail(:to => @user.email, :subject => I18n.t("mail.confirmation.subject"))
  end
end
