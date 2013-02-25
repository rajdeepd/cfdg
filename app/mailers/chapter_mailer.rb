class ChapterMailer < ActionMailer::Base
  default :from => "contact.cfdg@gmail.com"

  def block_unblock_member(user,chapter,status)
    @user = User.find(user)
    @chapter = chapter
    @status = status
    mail(:to => @user.email, :subject => "CFDG - chapter status")
  end

end