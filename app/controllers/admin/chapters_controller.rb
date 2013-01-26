class Admin::ChaptersController < ApplicationController
  before_filter :admin_required
  layout 'admin'

  def index
    @chapters = Chapter.applied_chapters
    respond_to do |format|
      format.html # index.html.erb
      format.js{ render layout: false }
    end
  end  


  def incubate
   @chapters = Chapter.incubated_chapters
   render :layout => false
  end

  def active
    @chapters = Chapter.active_chapters
    render :layout => false
  end

  def delist
    @chapters = Chapter.delist_chapters
    render :layout => false
  end

  def all
    @chapters = Chapter.all
    render :layout => false
  end

  def change_status
    chapter = Chapter.find(params[:id])
    msg = ""
    case params[:status]
    when "incubate"
      chapter.incubate
      chapter.update_attributes(:approved_on => chapter.updated_at)
      ChapterMailer.approval_mail(chapter).deliver
      ChapterMailer.newly_created_mail(chapter,User.all_receivers).deliver

      msg = "Approved on #{chapter.approved_on.strftime("%b %d, %Y")}"
    when "active"
      chapter.active
      msg = "#{chapter.chapter_status}"
    when "delist_to_incubate"
      chapter.delist_to_incubate
      msg = "#{chapter.chapter_status}"
    when "delist"
      chapter.delist
      msg = "#{chapter.chapter_status}"
    when "active_to_incubate"
      chapter.active_to_incubate
      msg = "#{chapter.chapter_status}"
    else
      chapter.deny
      chapter.update_attributes(:rejected_on => chapter.updated_at)
      msg = "Rejected on #{chapter.rejected_on.strftime("%b %d, %Y")}"
    end

    respond_to do |format|
      format.html # index.html.erb
      format.json{ render json: {:msg => msg , :id => chapter.id} , status:  :ok }
    end
  end

  def chapter_reply   
    @chapter = Chapter.find(params[:id])
    message = @chapter.messages.new(params[:message])
    message.save

    respond_to do |format|
      format.html
      format.js{}
    end
  end

  def add_secondary_coordinator
    @chapter = Chapter.find(params[:id])
    @members = @chapter.get_all_members
  end

  def create_secondary_coordinator
    member= ChapterMember.find(params[:member])
    @chapter = Chapter.find(params[:id])
    @chapter.save_secondary_coordinator(member)
    redirect_to add_secondary_coordinator_admin_chapter_path(@chapter)
  end

  def edit
    @chapter = Chapter.find(params[:id])

    respond_to do |format|
      format.html{ render :layout => false}
      format.js
    end
  end

  def update
    @chapters = Chapter.all
    @chapter = Chapter.find(params[:id])

    respond_to do |format|
      if @chapter.update_attributes(params[:chapter])
        format.js
      else
        render :action => 'edit'
      end
    end
  end

  def chairmans
    @chapters = Chapter.all
    render :layout => false
  end
end
