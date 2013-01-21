class ChaptersController < ApplicationController

  before_filter do
    locale = params[:locale]
    Carmen.i18n_backend.locale = locale if locale
  end

  def recommend_chapters

  end

  def subregion_options
    render partial: 'subregion_select'
  end

  # GET /chapters
  # GET /chapters.json
  def index
    @chapters = Chapter.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @chapters }
    end
  end

  # GET /chapters/1
  # GET /chapters/1.json
  def show
    @chapter = Chapter.find(params[:id])

    @is_part_of_chapter = false
    if current_user
      @is_part_of_chapter = @chapter.chapter_members.where({:user_id => current_user.id}).try(:first).present? 
    end

    @primary_coord = @chapter.chapter_members.where({:memeber_type => ChapterMember::PRIMARY_COORDINATOR}).try(:first)
    @secondary_coords = @chapter.chapter_members.where({:memeber_type => ChapterMember::SECONDARY_COORDINATOR}) || []
    @members = @chapter.chapter_members.where({:memeber_type => ChapterMember::MEMBER}) || []

    @totalcount = @chapter.chapter_members.size    

    get_upcoming_and_past_events
    @announcements = Announcement.all
    respond_to do |format|
      if request.xhr?  
        if(params[:chapter_home] == "true" and params[:page].blank?)
          format.html{render :partial => '/events/events_list'}
        else      #this is used for pagination
          format.js {}
        end
      else
        format.html # show.html.erb
        format.json { render json: @chapter }
      end
    end
  end


  # GET /chapters/new
  # GET /chapters/new.json
  def new
    #if @chapter
    #redirect_to @chapter
    #else
    @chapter = Chapter.new

    @chapter.chapter_type = current_user.is_student? ? Chapter::STUDENT : Chapter::CITY    

    if @chapter.is_type_student?
      @chapter.college = current_user.college
    else
      @chapter.city = current_user.city
    end

    @chapter.messages.build
    @admin = User.find_by_email("admin@cloudfoundry.com")

    respond_to do |format|
      format.html {render :layout => "create_chapter"}
      format.json { render json: @chapter }
    end
    #end
  end

  # GET /chapters/1/edit
  def edit    
    @chapter = Chapter.find(params[:id])
  end

  # POST /chapters
  # POST /chapters.json

  def create
    @admin = User.find_by_email("admin@cloudfoundry.com")

    @chapter = Chapter.new(params[:chapter])
    @chapter.setup_with_user(current_user)

    member = ChapterMember.new({ :memeber_type=>ChapterMember::PRIMARY_COORDINATOR, :user_id => @current_user.id })

    respond_to do |format|
      if @chapter.save
        member.chapter_id = @chapter.id
        member.save
        format.html { redirect_to @chapter, notice: ['Chapter was successfully created.'] }
        format.json { render json: @chapter, status: :created, location: @chapter }
      else
        flash[:error] = @chapter.errors.to_a
        format.html { render action: "new" , :layout => "create_chapter"}
        format.json { render json: @chapter.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /chapters/1
  # PUT /chapters/1.json
  def update
    @chapter = Chapter.find(params[:id])
    respond_to do |format|
      if @chapter.update_attributes(params[:chapter])
        format.html { redirect_to @chapter, notice: 'Chapter was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @chapter.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /chapters/1
  # DELETE /chapters/1.json
  def destroy
    @chapter = Chapter.find(params[:id])
    @chapter.destroy

    respond_to do |format|
      format.html { redirect_to chapters_url }
      format.json { head :no_content }
    end
  end

  def join_a_chapter
    @chapter = Chapter.find(params[:chapter_id])
    member = ChapterMember.new({:memeber_type=>ChapterMember::MEMBER, :user_id => @current_user.id, :chapter_id => @chapter.id}) 
    respond_to do |format|
      if member.save
        format.html { redirect_to @chapter }
        format.json { render json: @chapter, status: :success, location: @chapter }
      else
        format.html { redirect_to @chapter }
        format.json { render json: @chapter.errors, status: :unprocessable_entity }
      end
    end  
  end 

  def chapter_admin_home_page
    @chapter = Chapter.find(params[:chapter_id])    
    @chapter_events = @chapter.events.sort
    @two_chapter_events = @chapter_events.take(2)
    respond_to do |format|
      format.js {render :partial => 'chapter_admin_home_page' }
    end
  end 

  def get_upcoming_and_past_events
    @all_events = Event.find_all_by_chapter_id(@chapter.id) || []
    @past_events = []
    @upcoming_events = []
    @all_events.each do |event|       
      if(!event.event_start_date.blank? && Time.parse(event.event_start_date+" "+ event.event_start_time) >= Time.now)
        @upcoming_events.push(event)
      else
        @past_events.push(event)
      end
    end
    @two_upcoming_events = @upcoming_events.sort!.reverse!.take(2)
    #@upcoming_events = @upcoming_events.paginate(:page => params[:page], :per_page => 5)
    @past_events.sort!
    @past_events = @past_events.paginate(:page => params[:page], :per_page => 10)
  end

  def recommend
    @chapters = Chapter.find_chapter_for_user(current_user)

    respond_to do |format|
      format.html
    end
  end
end
