class ChaptersController < ApplicationController

  respond_to :js, :html

  before_filter do
    locale = params[:locale]
    Carmen.i18n_backend.locale = locale if locale
  end
  before_filter :chapter, :only=>[:chapter_gallery, :show, :detail, :update, :destroy]

  def index
    @chapters = Chapter.all
    respond_with @chapters
  end

  def new
    @chapter = Chapter.new
    @chapter.messages.build
    @admin = User.site_admin
    respond_with @chapter do |f|
      f.html {render layout: "create_chapter"}
      f.json
    end
  end

  def chapter_gallery
    @event = Event.find(params[:event_id], :include=> :event_galleries)
    respond_with @chapter
  end

  def detail
    @is_part_of_chapter, @primary_coordinator, @secondary_coordinators, @members, @totalcount, @marker = @chapter.build_show_hash
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

  def edit
  end

  def create
    @admin = User.admin
    city = City.find(params[:chapter_city_name])
    chapter_name = "CFDG - " + city.name.try(:titleize)
    @chapter = Chapter.create_new_chapter(params,chapter_name)

    respond_to do |format|
      if @chapter.save
        format.html { redirect_to detail_chapter_path(@chapter), notice: 'Chapter was successfully created.' }
        format.json { render json: @chapter, status: :created, location: @chapter }
      else
        format.html { render action: "new" , :layout => "create_chapter"}
        format.json { render json: @chapter.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
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

  def show
    @is_part_of_chapter, @primary_coordinator, @secondary_coordinators, @members, @totalcount = @chapter.build_show_hash
    get_upcoming_and_past_events
    @announcements = Announcement.all
    respond_to do |format|
      if request.xhr?
        if(params[:chapter_home] == "true" and params[:page].blank?)
          format.html{render :partial => '/events/events_list'}
        else
          format.js {}
        end
      else
        format.html # show.html.erb
        format.json { render json: @chapter }
      end
    end
  end

  def join_a_chapter
    @chapter = Chapter.find(params[:chapter_id])
    member = @chapter.add_member(:memeber_type=>ChapterMember::MEMBER)
    respond_to do |format|
      if member
        ChapterNotifications.chapter_joined(@chapter,@current_user).deliver
        format.html { redirect_to detail_chapter_path(@chapter),notice: 'Successfully joined the chapter.' }
        format.json { render json: @chapter, status: :success, location: @chapter }
      else
        format.html { redirect_to @chapter,notice: 'Unable to join the chapter.' }
        format.json { render json: @chapter.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @chapter.destroy
    respond_to do |format|
      format.html { redirect_to chapters_url }
      format.json { head :no_content }
    end
  end

  private

  def get_upcoming_and_past_events
    @all_events = 
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

  def chapter
    @chapter = Chapter.find_by_id(params[:id])
  end

end