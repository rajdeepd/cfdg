class ChapterMailer < ActionMailer::Base
  default :from => "contact.cfdg@gmail.com"

  def block_unblock_member(user,chapter,status)
    @user = User.find(user)
    @chapter = chapter
    @status = status
    mail(:to => @user.email, :subject => "CFDG - chapter status")
  end

  def manage_coordinators(user,chapter,member_type)
    @member_type = member_type
    @user = User.find(user)
    @email = user.email
    @chapter = chapter
    mail(:to => @user.email, :subject => "CFDG - Activity" )

  end

  def chapter_invitation(user,email,chapter)
    @chapter = chapter
    @user = user
    mail(:to => email, :subject => "CFDG - Chapter Invitation" )
  end

end