class UserMailer < ActionMailer::Base
  default :from => "contact.cfdg@gmail.com"

  def welcome_mail(user)
    @user = user
    mail(:to => "kunalb@weboniselab.com",:bcc => ["aditya@weboniselab.com", "apurva@weboniselab.com"], :subject => "Welcome mail")
  end

  def send_custom_mail(to,subject,body)
    @user = to
    @body = body
    mail(:to => to, :subject => subject)
  end

end