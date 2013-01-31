class ChaptersController < ApplicationController

  before_filter do
    locale = params[:locale]
    Carmen.i18n_backend.locale = locale if locale
  end

  def subregion_options
    #render partial: 'subregion_select'
    logger.info "@@@@@@@@@@@@@@@@@@ inside subregion action @@@@@@@@@@@@@@@@@@@@#{params}"
    @country = Country.find(params[:country_id])
    @states = @country.states
    respond_to do |format|
      format.js
    end
  end

  def select_city
    logger.info "@@@@@@@@@@@@@@@@@@ inside select city action @@@@@@@@@@@@@@@@@@@@#{params}"
    @state = State.find(params[:state_id])
    @cities = @state.cities
    respond_to do |format|
      format.js
    end
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
    marker =[]
    if @chapter.geolocation.present?
      geo_tag =@chapter.geolocation
      marker <<{:lat => geo_tag.latitude, :lng => geo_tag.longitude, :title => geo_tag.title}
    end
    @marker =marker.to_json
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

  def detail
    @chapter = Chapter.find(params[:id])
    @is_part_of_chapter = false
    if current_user
      @is_part_of_chapter = @chapter.chapter_members.where({:user_id => current_user.id}).try(:first).present?
    end

    @primary_coordinator = @chapter.chapter_members.where({:memeber_type => ChapterMember::PRIMARY_COORDINATOR}).try(:first)
    @secondary_coordinators = @chapter.chapter_members.where({:memeber_type => ChapterMember::SECONDARY_COORDINATOR}) || []
    @members = @chapter.chapter_members.where({:memeber_type => ChapterMember::MEMBER}) || []

    @totalcount = @chapter.chapter_members.size

    get_upcoming_and_past_events
    marker =[]
    if @chapter.geolocation.present?
      geo_tag =@chapter.geolocation
      marker <<{:lat => geo_tag.latitude, :lng => geo_tag.longitude, :title => geo_tag.title}
    end
    @marker =marker.to_json
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

    def chapter_gallery
      @chapter = Chapter.find(params[:id])
      @event = Event.find(params[:event_id])
      @event_images = Event.find(params[:event_id]).event_galleries
      logger.info "################## event #############{@event_images.inspect}"
    end

  # GET /chapters/new
  # GET /chapters/new.json
  def new
    @chapter = Chapter.new
    @chapter.messages.build
    @admin = User.find_by_email("admin@cloudfoundry.com")

    respond_to do |format|
      format.html {render :layout => "create_chapter"}
      format.json { render json: @chapter }
    end
  end

  # GET /chapters/1/edit
  def edit
    @chapter = Chapter.find(params[:id])
  end

  # POST /chapters
  # POST /chapters.json

  def create
    @admin = User.find_by_email("admin@cloudfoundry.com")
    #params[:chapter][:name] = "CFDG - " + params[:chapter][:city_name].try(:titleize)
    city = City.find(params[:chapter_city_name])
    chapter_name = "CFDG - " + city.name.try(:titleize)
    #@chapter = Chapter.new(params[:chapter])
    @chapter = Chapter.create_new_chapter(params,chapter_name)
    logger.info "######################### inside created action #{@chapter.inspect}"
    member = ChapterMember.new({:memeber_type=>ChapterMember::PRIMARY_COORDINATOR, :user_id => @current_user.id})

    respond_to do |format|
      if @chapter.save
        member.chapter_id = @chapter.id
        member.save
        format.html { redirect_to @chapter, notice: 'Chapter was successfully created.' }
        format.json { render json: @chapter, status: :created, location: @chapter }
      else
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
        ChapterNotifications.chapter_joined(@chapter,@current_user).deliver
        #format.html { redirect_to @chapter }
        format.html { redirect_to detail_chapter_path(@chapter),notice: 'Successfully joined the chapter.' }
        format.json { render json: @chapter, status: :success, location: @chapter }
      else
        format.html { redirect_to @chapter,notice: 'Unable to join the chapter.' }
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

  def search
    logger.info params.inspect
    @chapters = Chapter.search_chapters(params[:query])
    if @chapters.length ==1
      redirect_to chapter_path(@chapters.first)
    end
  end

  def search_chapter_list
    @chapters = Chapter.search_chapters(params[:query])
    if params[:chapter_type] != "All"
      @chapters = @chapters.select{|i| i.chapter_type.downcase == params[:chapter_type].downcase}
    end
    redirect_to list_chapters_path(:search_results => @chapters.collect{|i| i.id}, :query => params[:query])
  end

  def list
    if params[:query].present?
      @chapters =Chapter.where(:id => params[:search_results])
    else
    all_chapters = Chapter.incubated_or_active || []
    if params[:all_chapters] == "true"
      @chapters = all_chapters
    else
      country = get_country(request)
      chapter_inside_country = all_chapters.select{|i| i.country_name == country}
      if chapter_inside_country.empty?
        @chapters = all_chapters
      else
        @chapters = chapter_inside_country
      end

      #binding.remote_pry
    end
    end

    @chapters.sort_by!{|i| -i.chapter_members.count}


  end
end
