class ChapterNotifications < ActionMailer::Base
  default from: "contact.cfdg@gmail.com"

  def chapter_joined(chapter,user)
    logger.info "########## join a chapter ###############"
    @user = user
    @chapter = chapter
    mail(:to => user.email, :subject => "Chapter Joined")
  end
end
