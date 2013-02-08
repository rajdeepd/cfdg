class ChaptersController < ApplicationController

  respond_to :js, :html

  before_filter do
    locale = params[:locale]
    Carmen.i18n_backend.locale = locale if locale
  end

  def index
    @chapters = Chapter.all
    respond_with @chapters
  end

  def new
    @chapter = Chapter.new
    @chapter.messages.build
    @admin = User.find_by_email("admin@cloudfoundry.com")

    respond_to do |format|
      format.html {render :layout => "create_chapter"}
      format.json { render json: @chapter }
    end
  end

  def show
    @chapter = Chapter.find(params[:id], :include=>:chapter_members)
    @is_part_of_chapter = @chapter.chapter_members.where(:user_id=> current_user.try(:id)).any?

    @primary_coordinator = @chapter.chapter_members.where(:memeber_type => ChapterMember::PRIMARY_COORDINATOR).first
    @secondary_coordinators = @chapter.chapter_members.where({:memeber_type => ChapterMember::SECONDARY_COORDINATOR})
    @members = @chapter.chapter_members.where(:memeber_type => ChapterMember::MEMBER)

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

end