class HomeController < ApplicationController
  before_filter :announcements , :only => [:index, :wiki]
  before_filter :chapters , :only => [:index, :directory, :about]
  #autocomplete :city, :details

  layout "application"

  def index
    @country, @country_count, @chapter_count, @user_count, @event_count, @upcoming_events = Event.build_hash
    if @current_user && @current_user.fullname?
      redirect_to edit_user_path(current_user,:email => current_user.email)
      flash[:error] = "Please fill up your name."
    end
  end

  def directory
  end

  def about
  end

  def wiki
    respond_to do |format|
      format.html {render :layout => "wiki_page"}
    end
  end

  def login

  end

  def autocomplete_city_details
    # TODO: Use scope and move model logic to corresponding City model
    city = City.where("details like ?","#{params[:term]}%")
    data = city.collect{|i| {:id => i.details, :value => i.details}}
    respond_to do |format|
      format.json{ render :json => data}
    end
  end

  def login

  end

  def autocomplete_city_details
    # TODO: Use scope and move model logic to corresponding City model
    city = City.where("details like ?","#{params[:term]}%")
    data = city.collect{|i| {:id => i.details, :value => i.details}}
    respond_to do |format|
      format.json{ render :json => data}
    end
  end

  private

  def get_markers
    markers = []
    @chapters.each do |chapter|
      address = get_address(chapter)
      if(!address.blank?)
        begin
          options = Gmaps4rails.geocode(address)
          markers << {:lat => options.first[:lat], :lng => options.first[:lng], :title => options.first[:matched_address], :link => chapter_path(chapter)}
        rescue Gmaps4rails::GeocodeStatus
        end
      end
    end
    markers
  end

  def announcements
    @announcements = Announcement.order("created_at DESC").first(3)
  end

  def chapters
    @chapters = Chapter.incubated_or_active
    @markers = get_geocodes.to_json
  end

  def get_address(chapter)
    city = chapter.city_name.blank? ? "" : chapter.city_name + ","
    state = chapter.state_name.blank? ? "" : chapter.state_name + ","
    country = chapter.country_name.blank? ? "" : chapter.country_name
    city + state + country
  end


  def get_geocodes
    markers = []
    @chapters.each do |chapter|
      geo_tag= chapter.geolocation
      markers << {:lat => geo_tag.latitude, :lng => geo_tag.longitude, :title => geo_tag.title, :link => chapter_path(chapter)}
    end
    markers
  end

end