class ChapterMailer < ActionMailer::Base
  layout 'mail_default'
  default :from => "contact.cfdg@gmail.com"
  
  def new_chapter_mail(chapter)
    @chapter = chapter
    @admin = User.admin_user
    @primary_coord = @chapter.get_primary_coordinator
    
    mail(:to => @admin.email, :subject => I18n.t("mail.chapter_mailer.new_chapter.subject"))
  end

  def approval_mail(chapter)
    @chapter = chapter
    @primary_coord = @chapter.get_primary_coordinator
    
    mail(:to => @primary_coord.email, :subject => I18n.t("mail.chapter_mailer.approval.subject", :chapter_name => @chapter.name))
  end

  def denial_mail(chapter)
    @chapter = chapter
    @primary_coord = @chapter.get_primary_coordinator

    mail(:to => @primary_coord.email, :subject => I18n.t("mail.chapter_mailer.denial.subject"))
  end

  def newly_created_mail(chapter, receivers)
    @chapter = chapter
    @primary_coord = @chapter.get_primary_coordinator
    
    mail(:bcc => receivers, :subject => I18n.t("mail.chapter_mailer.newly_created.subject", :chapter_name => @chapter.name))
  end
end