require 'eventbrite-client'
require 'oauth2'
class EventsController < ApplicationController
  protect_from_forgery :except => [:image_gallery_upload,:delete_event_gallery_image, :index]
  before_filter :set_profile_page
  before_filter :check_authorization ,:only => [:download_list]

  respond_to :js, :html

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
    logger.info("#########################################{(CGI::escape form_authenticity_token).inspect}")
    logger.info("#########################################{form_authenticity_token.inspect}")
    @event = Event.find(params[:id])
    #@event = Event.find(9)
    @emails = ''
    @members = @event.event_members.includes(:user).collect{|i| i.user}
    @event.event_members.each do |member| @emails << (member.user.try(:email).to_s+"\;")  end

    if @event.event_galleries.present?
      @all_event_images =  @event.event_galleries
    end

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
    if !@event.is_cancelled? and !@event.am_i_member?(@current_user.id)
      @event_memeber = EventMember.new(:event_id => @event.id, :user_id => current_user.id)
      @event_memeber.save!
      EventNotification.rsvped_event(@event,@current_user).deliver
    end
    chapter_events = Event.find_all_by_chapter_id(@event.chapter_id) || []
    get_upcoming_and_past_events(chapter_events, true)
    @chapter = Chapter.find(@event.chapter_id)
    if !@chapter.am_i_chapter_memeber?(@current_user.id)
      ChapterMember.create({:memeber_type=>ChapterMember::MEMBER, :user_id => @current_user.id, :chapter_id => @chapter.id})
    end
    @profile_page = false
    respond_to do |format|
      format.js {render :partial => 'events_list' }# new.html.erb
    end
  end

  def delete_an_event
    @event = Event.find(params[:event_id])
    @chapter = @event.chapter
    @event.event_members.each do|member| member.soft_delete! end
    @event.soft_delete!

    chapter_events = Event.find_all_by_chapter_id(@event.chapter_id) || []
    get_upcoming_and_past_events(chapter_events, true)
    @profile_page = false

    respond_to do |format|
      format.js {render :partial => 'events_list' }# new.html.erb
    end
  end

  def unfollow_an_event
    @event = Event.find(params[:id])
    @member = @event.event_members.includes(:user).select{|i| i.user == @current_user}.first
    @member.delete
    @profile_page = false
    chapter_events = Event.find_all_by_chapter_id(@event.chapter_id) || []
    get_upcoming_and_past_events(chapter_events, true)
    respond_to do |format|
      format.js {render :partial => 'events_list' }# new.html.erb
    end
  end

  def cancel_event
    @event = Event.find(params[:event_id])
    @chapter = @event.chapter
    to_email = @chapter.get_primary_coordinator.email
    bcc_emails = @event.event_members.includes(:user).collect{|i| i.user.email} - [to_email]
    @event.is_cancelled = true
    @event.save
    EventNotification.event_cancellation(@event,to_email,bcc_emails).deliver
    #SES.send_raw_email(EventNotification.event_cancellation(@event,to_email,bcc_emails))
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
        @event_memeber = EventMember.new(:event_id => @event.id, :user_id => @current_user.id)
        @event_memeber.save!
        @chapter = Chapter.find(@event.chapter_id)
        @chapter_events = @chapter.events.sort
        to_email = @chapter.get_primary_coordinator.email
        bcc_emails=@chapter.chapter_members.includes(:user).collect{|i| i.user.email} - [to_email]
        @two_chapter_events = @chapter_events.take(2)
        EventNotification.event_creation(@event,to_email,bcc_emails,@chapter).deliver
        format.js
      else
        flash.now[:error] =  @event.errors.messages
        format.js
      end

    end
  end

  # PUT /events/1
  # PUT /events/1.json
  def update

    @event = Event.find(params[:id])

    respond_to do |format|
      if @event.update_attributes(params[:event])
        format.html { redirect_to @event, notice: 'Event was successfully updated.' }
        @chapter = Chapter.find(@event.chapter_id)
        if params[:send_email].present?
          to_email = @chapter.get_primary_coordinator.email
          bcc_emails = @event.event_members.includes(:user).collect{|i| i.user.email} -[to_email]
          #EventNotification.delay.event_edit(@event,emails,@chapter)
          EventNotification.event_edit(@event,to_email,bcc_emails,@chapter).deliver
          #SES.send_raw_email(EventNotification.event_edit(@event,to_email,bcc_emails,@chapter))
        end
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @event.errors, status: :unprocessable_entity }
      end
    end
  end

  def invite_friends_for_event
    event = Event.find(params[:id])
    user = current_user
    emails = params[:email].split(/\s*[,;]\s*|\s{1,}|[\r\n]+/).join(",")
    logger.info"############### #{emails}"
    chapter = event.chapter
    EventNotification.event_invitation(user,event,chapter)
    #ChapterMailer.chapter_invitation(user,emails,chapter).deliver
    flash[:notice] = "Email sent successfully"
    redirect_to event_path
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
    @comment.created_by = @current_user.id
    @comment.updated_by = @current_user.id
    @all_event_images = @event.event_galleries
    respond_to do |format|
      if(@comment.save)
        format.js {}
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

  def download_list
    require 'csv'
    @event = Event.find(params[:id])
    @members = @event.event_members.includes(:user).collect{|i| i.user}
    logger.info("inside csv")
    #render :json => @members
    csv_string = CSV.generate do |csv|
      csv << ["Full Name" , "Email" , "Contact Number"]
      @members.each do |p|
        csv << [ p.fullname,p.email,p.mobile]
      end
    end
    respond_to do |format|

      format.html  { send_data csv_string,
                               :type => "text/csv; charset=iso-8859-1; header=present",
                               :disposition => "attachment; filename=event.csv" }
      format.json {render :json => @members}
    end
  end

  def check_authorization
    @event = Event.find(params[:id])
    if @current_user.present?  and !@event.can_i_delete?(@current_user.id, @event.chapter_id)
      redirect_to event_path(@event)
    end
  end



  def initialise_eventbrite_client
    event_brite_oauthtoken = EventbriteOauthToken.find_by_user_id(@current_user.id)
    if(!event_brite_oauthtoken.nil?)
      @eb_client = EventbriteClient.new({ access_token: event_brite_oauthtoken.event_brite_token})
    else
      @auth_client_obj = OAuth2::Client.new(EVENTBRITE_CLIENT_ID, EVENTBRITE_CLIENT_SECRET, {:site => EVENTBRITE_URL})
      @accept_url = @auth_client_obj.auth_code.authorize_url( :redirect_uri => EVENTBRITE_REDIRECT_URL)
    end
  end

  def image_gallery_upload
    @event = Event.find(params[:id])
    if params[:Filedata].present?
      upload_image = @event.event_galleries.new(:image => params[:Filedata])
      upload_image.save!
    end
    @all_event_images = @event.event_galleries
    respond_to do |format|
      format.js {render :layout => false}
    end

  end

  def show_all_event_images
    @event = Event.find(params[:id])
    @all_event_images = @event.event_galleries
  end

  def on_the_spot_registration
    @event = Event.find(params[:id])
    @members = @event.event_members
    @user = User.new
  end

  def create_on_spot_user
    @event = Event.find(params[:id])
    @event_member, @flag, @user = @event.onspot_registration params
    respond_to do |format|
      format.js {}
    end
  end

  def attending
    @event = Event.find(params[:id])
    @event.update_attendee_status params[:user_id]
    respond_with @event do |f|
      f.js{render nothing: true}
    end
  end


  def delete_event_gallery_image
    #EventGallery.delete_all("id IN #{params[:event_gallery_ids]}")
    EventGallery.delete params[:event_gallery_ids].map {|event_gallery_id| event_gallery_id}
    @event_gallery_ids = params[:event_gallery_ids].map {|event_gallery_id| event_gallery_id.to_i}
    respond_to do |format|
      format.js
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
