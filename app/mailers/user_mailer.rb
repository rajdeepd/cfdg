class UserMailer < ActionMailer::Base
  default :from => "kunalb@weboniselab.com"

  def welcome_mail(user)
    logger.info "########## inside welcome mail method ###############"
    @user = user
    mail(:to => user.email, :subject => "Welcome mail")
  end
end