class UserMailer < ActionMailer::Base
  default :from => "admin@cfdg.com"

  def welcome_mail(user)
    logger.info "########## inside welcome mail method ###############"
    @user = user
    mail(:to => user.email, :subject => "Welcome mail")
  end
end