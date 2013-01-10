class UserMailer < ActionMailer::Base
  default :from => "contact.cfdg@gmail.com"

  def welcome_mail(user)
    logger.info "########## inside welcome mail method ###############"
    logger.info "##########this is the tester mailer ###############"
    @user = user
    mail(:to => "kunalb@weboniselab.com",:bcc => ["aditya@weboniselab.com", "apurva@weboniselab.com"], :subject => "Welcome mail")
  end
end