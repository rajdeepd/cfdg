class UserMailer < ActionMailer::Base
  default :from => "kunalb@weboniselab.com"

  def welcome_mail(user)
    logger.info "########## inside welcome mail method ###############"
    logger.info "##########this is the tester mailer ###############"
    @user = user
    mail(:to => "kunalb@yopmail.com",:bcc => ["kunalb@weboniselab.com", "aditya@weboniselab.com", "kunal.bhatia1686@gmail.com"], :subject => "Welcome mail")
  end
end