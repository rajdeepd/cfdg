class ChapterMailer < ActionMailer::Base
  layout 'mail_default'
  default :from => "contact.cfdg@gmail.com"
  
  def new_chapter_mail(chapter)
    @chapter = chapter
    @admin = User.admin_user
    @primay_coord = @chapter.get_primary_coordinator
    
    mail(:to => @admin.email, :subject => I18n.t("mail.chapter_mailer.new_chapter.subject"))
  end
end
