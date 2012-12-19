require 'eventbrite-client'
require 'oauth2'
class EventsController < ApplicationController
  # GET /events
  # GET /events.json
  #before_filter :initialise_eventbrite_client, :except => ['create_event_comment', 'show']
  before_filter :set_profile_page

  def index
    @events = Event.all
    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @event }
    end
  end

  # GET /events/1
  # GET /events/1.json
  def show
    @event = Event.find(params[:id])
    @emails = ''
    @event.event_members.each do |member| @emails << (member.user.try(:email).to_s+"\;")  end

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @event }
    end
  end

  # GET /events/new
  # GET /events/new.json
  def new
    @event = Event.new
    @event.chapter_id = params[:chapter_id]
    respond_to do |format|
      format.js {render :partial => 'form'} # new.html.erb
      format.json { render json: @event }
    end
  end

  def set_profile_page
    @profile_page = true
  end

  def oauth_reader
    if !params[:code].blank?
      access_token_obj = @auth_client_obj.auth_code.get_token(params[:code], { :redirect_uri => EVENTBRITE_REDIRECT_URL, :token_method => :post })
      eventbrite_entry = EventbriteOauthToken.new(:user_id => @current_user.id, :event_brite_token => access_token_obj.token)
      eventbrite_entry.save!

      @eb_client = EventbriteClient.new({ access_token: access_token_obj.token})
    end
    respond_to do |format|
      format.html {redirect_to profile_path}# new.html.erb
    end
  end



  def userevents
    chapter_id = params[:chapter_id]
    #@chapter = Chapter.find(chapter_id)
    @chapter = Chapter.find(params[:chapter_id])
    #user_events = EventMember.find_all_by_user_id(@current_user.id, :include => ['event'], :conditions => "events.chapter_id = #{chapter_id} ") || []
    chapter_events = Event.find_all_by_chapter_id(params[:chapter_id])

    #get_upcoming_and_past_events(user_events)
    upcoming_and_past_events(chapter_events)

    respond_to do |format|
      if !params["page"].blank?
        format.js
      else
        format.js {render :partial => 'new_events_list' }# new.html.erb
      end
    end

  end


  # GET /events/1/edit
  def edit
    @event = Event.find(params[:id])
  end



  def follow_an_event
    @event = Event.find(params[:event_id])
    @event_memeber = EventMember.new(:event_id => @event.id, :user_id => current_user.id)
    @event_memeber.save!
    #if @event.attendees_count.nil?
    #elsif @event.attendees_count > 0
    #  @event.attendees_count -= 1
    #  @event.save!
    #end
    chapter_events = Event.find_all_by_chapter_id(@event.chapter_id) || []
    get_upcoming_and_past_events(chapter_events, true)
    @chapter = Chapter.find(@event.chapter_id)
    @profile_page = false
    respond_to do |format|
      format.js {render :partial => 'events_list' }# new.html.erb
    end
  end

  def delete_an_event
    @event = Event.find(params[:event_id])
    @event.event_members.each do|member| member.soft_delete! end
    @event.soft_delete!

    chapter_events = Event.find_all_by_chapter_id(@event.chapter_id) || []
    get_upcoming_and_past_events(chapter_events, true)
    @profile_page = false

    respond_to do |format|
      format.js {render :partial => 'events_list' }# new.html.erb
    end
  end



  # POST /events
  # POST /events.json
  def create
    @event = Event.new(params[:event])
    respond_to do |format|
      if @event.save
        start_date = (params[:event][:event_start_date].blank? or params[:event][:event_start_time].blank?) ? "" : Time.parse(params[:event][:event_start_date]+" " +params[:event][:event_start_time]).strftime('%Y-%m-%d %H:%M:%S')
        end_date = (params[:event][:event_end_date].blank? or  params[:event][:event_end_time].blank?) ? "" : Time.parse(params[:event][:event_end_date]+" " +params[:event][:event_end_time]).strftime('%Y-%m-%d %H:%M:%S')

        #venue_id = get_venue_id
        #eventbrite_event = @eb_client.event_new(:venue_id => venue_id , :organizer_id =>  EVENTBRITE_ORGANIZATION_ID , :name => params[:name], :start_date => start_date, :end_date => end_date,  :title => params[:event][:title], :description => params[:event][:description])
        #eventbrite_id = eventbrite_event.parsed_response["process"]["id"].to_s
        #@event.update_attribute(:eventbrite_id, eventbrite_id)

        @event_memeber = EventMember.new(:event_id => @event.id, :user_id => current_user.id)
        @event_memeber.save!

        @chapter = Chapter.find(@event.chapter_id)
        @chapter_events = @chapter.events.sort
        @two_chapter_events = @chapter_events.take(2)
        format.js
      else
        format.js
      end

    end
  end

  # PUT /events/1
  # PUT /events/1.json
  def update

    @event = Event.find(params[:id])

    respond_to do |format|
      if @event.update_attributes!(params[:event])
        format.html { redirect_to @event, notice: 'Event was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @event.errors, status: :unprocessable_entity }
      end
    end
  end

  def full_event_content
    @event = Event.find(params[:event_id])
    respond_to do |format|
      format.js { render :partial => "/events/full_event" }
    end
  end

  def create_event_comment
    @event = Event.find(params[:comment][:commentable_id])
    @comment = Comment.new(params[:comment])

    respond_to do |format|
      if(@comment.save)
        format.js { render :partial => "/events/full_event" }
      end
    end

  end
  def title_list
    chapter_id = params[:chapter_id]
    @events = Event.where("chapter_id = ? and title like (?)", chapter_id, "%#{params[:term]}%")
    data = []
    @events.each_with_index do |event,i|
      data[i] = { "label" => "#{event.title}", "value" => "#{event.id}"}
    end

    render json: data.to_json
  end



  def initialise_eventbrite_client
    logger.info("#############################{@current_user.inspect}")
    event_brite_oauthtoken = EventbriteOauthToken.find_by_user_id(@current_user.id)
    if(!event_brite_oauthtoken.nil?)
      @eb_client = EventbriteClient.new({ access_token: event_brite_oauthtoken.event_brite_token})
    else
      @auth_client_obj = OAuth2::Client.new(EVENTBRITE_CLIENT_ID, EVENTBRITE_CLIENT_SECRET, {:site => EVENTBRITE_URL})
      @accept_url = @auth_client_obj.auth_code.authorize_url( :redirect_uri => EVENTBRITE_REDIRECT_URL)
    end
  end

  def image_gallery_upload
    #@gallery = Gallery.find(params[:id])
    #@count = @gallery
    #params[:image].each do |i|
    #  begin
    #    @image = @gallery.images.new(:image => i)
    #    @image.save
    #  rescue
    #  end
    #end
    logger.info "inside action ######################################"
    respond_to do |format|
      #if @image.
      #    format.html {redirect_to :layout => false, :action => "show"}
      #  format.js {render :partial => "gallery_images", :collection => @image, :layout => false }
        format.js{render :layout => false}
      #else
      #  format.html {redirect_to request.referrer, :notice => "Unsuccessfull"}
      #  format.js{render :layout => false}

    end
  end



  protected

  def upcoming_and_past_events(chapter_events)
    @all_events = []
    @past_events = []
    @upcoming_events = []
    chapter_events.each do |event|
      @all_events.push(event)
      if(Time.parse(event.event_start_date+" "+ event.event_start_time) >= Time.now)
        @upcoming_events.push(event)
      else
        @past_events.push(event)
      end
    end
    @past_events = @past_events.paginate(:page => params[:page], :per_page => 10).sort!
    @two_upcoming_events = @upcoming_events.sort!.reverse!.take(2)
  end


  def get_upcoming_and_past_events(user_events, is_chapter_event=false)
    @all_events = []
    @past_events = []
    @upcoming_events = []
    user_events.each do |user_event|
      event = user_event
      if(!is_chapter_event)
        event = user_event.event
      end
      @all_events.push(event)

      if(!event.event_start_date.blank? && Time.parse(event.event_start_date+" "+ event.event_start_time) >= Time.now)
        @upcoming_events.push(event)
      else
        @past_events.push(event)
      end
    end
    @two_upcoming_events = @upcoming_events.sort!.reverse!.take(2)

    @past_events.sort!
    @past_events = @past_events.paginate(:page => params[:page], :per_page => 10)

  end

  def get_venue_id
    venues_list = @eb_client.user_list_venues.parsed_response["venues"]
    existing=venues_list.select do |venue|   venue["venue"]["name"] == params[:event][:venue]  end

    if(existing.blank?)
      organizers_response = @eb_client.user_list_organizers
      organizer = organizers_response["organizers"].select do |org|  org["organizer"]["name"] =="cloudfoundry"  end

      if(organizer.blank?)
        organization = @eb_client.organizer_new(:name => "cloudfoundry")
        organization_id = organization.parsed_response["process"]["id"]
      else
        organization_id = organizer[0]["organizer"]["id"]
      end

      venue = @eb_client.venue_new(:organizer_id => organization_id, :name => params[:event][:venue],  :location => params[:event][:location], :address => params[:event][:address_line1], :address2 => params[:event][:address_line2] ,:country_code => "IN")
      venue_id = venue.parsed_response["process"]["id"]
    else
      venue_id = existing[0]["venue"]["id"]
    end

    venue_id

  end



end
