require 'eventbrite-client'
require 'oauth2'
class EventsController < ApplicationController
  protect_from_forgery :except => [:image_gallery_upload]
  before_filter :set_profile_page
  before_filter :check_authorization ,:only => [:download_list]
  before_filter :event, :only=> [:show, :edit, :update, :delete_an_event, :unfollow_an_event, :cancel_event, :check_authorization, :image_gallery_upload, :show_all_event_images, :update_markers, :join_event, :new_agenda_and_speaker, :create_agenda, :speaker_delete]
  respond_to :js, :html, :json

  def index
    @events = Event.all
    respond_with @events
  end

  def show
    @emails, @members, @coordinaters, @all_event_images, @marker = @event.build_show_hash
    respond_with @event
  end

  def new
    @chapter = Chapter.find_by_id(params[:chapter_id])
    @event = @chapter.events.build
    respond_with @event
  end

  def create
    @chapter = Chapter.find(params[:chapter_id])
    @event = @chapter.events.new(params[:event])
    if @event.save
      redirect_to new_agenda_and_speaker_event_path(@event), :notice => "Event created successfully"
    else
      render :action => :new
    end
  end

  def edit
  end

  def update
  respond_to do |format|
      if @event.update_attributes(params[:event])
        format.html { redirect_to @event, notice: 'Event was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @event.errors, status: :unprocessable_entity }
      end
    end
  end

  def delete_an_event
    @chapter = @event.chapter
    @event.destroy
    get_upcoming_and_past_events(@chapter.events, true)
    @profile_page = false
    respond_with @event do |f|
      f.js{render "event_list"}
    end
  end

  def unfollow_an_event
    # @member = @event.event_members.includes(:user).select{|i| i.user == @current_user}.first
    @member = @event.event_members.find_by_id(@currnet_user.id)
    @member.destroy
    @profile_page = false
    respond_with @event do |format|
      format.js {render :partial => 'events_list' }
    end
  end

  def cancel_event
    @event.cancel_event
    get_upcoming_and_past_events(@event.chapter.events, true)
    @profile_page = false
    respond_with @event do |format|
      format.js {render 'events_list' }
    end
  end

  def userevents
    @chapter = Chapter.find(params[:chapter_id], :include=>:events)
    upcoming_and_past_events(@chapter.events)

    respond_to do |format|
      if params["page"]
        format.js
      else
        format.js {render :partial => 'new_events_list' }# new.html.erb
      end
    end
  end

  def full_event_content
    @event = Event.find(params[:event_id])
    respond_to do |format|
      format.js { render "/events/full_event" }
    end
  end

  def create_event_comment
    @event = Event.find(params[:comment][:commentable_id], include: event_galleries)
    @comment = Comment.new(params[:comment])
    respond_to do |format|
      if(@comment.save)
        format.js
      end
    end
  end

  def image_gallery_upload
    if params[:Filedata]
      upload_image = @event.event_galleries.new(:image => params[:Filedata])
      upload_image.save!
    end
    @all_event_images = @event.event_galleries
    respond_to do |format|
      format.js {render :layout => false}
    end
  end

  def show_all_event_images
    @all_event_images = @event.event_galleries
  end

  def update_markers
    markers = params[:data].gsub(/[^0-9A-Za-z,.]/, '').split(",")
    @geolocation = @event.event_geolocation.merge({:latitude=>markers[0], :longitude=>markers[1]})
    @geolocation.save
    render :layout => false
  end

  def event_listing
    @upcoming_events = Event.get_upcoming_events.sort_by!{|i| (Time.parse(i.event_start_date))}.reverse!
    @past_events = Event.get_past_events.sort_by!{|i| (Time.parse(i.event_start_date))}.reverse!
  end

  def search_event_list
    @events = Event.search_event_chapter(params[:query])
    if @events.any?
      @upcoming_events = @events.collect{|event| event if Time.parse(event.event_start_date+" "+ event.event_start_time) >= Time.now}.compact
      @past_events = @events.collect{|event| event if Time.parse(event.event_start_date+" "+ event.event_start_time) < Time.now}.compact
    end
    respond_to do |format|
       format.js
       format.html
     end
  end

  def join_event
    if !@event.is_cancelled? and !@event.am_i_member?(@current_user.id)
      @event_memeber = @event.t_members.create( :user_id => current_user.id)
      EventNotification.rsvped_event(@event,@current_user).deliver  # move this to observer
    end
    get_upcoming_and_past_events(@event.chapter.events, true)
    @chapter = Chapter.find(@event.chapter_id)
    if !@chapter.am_i_chapter_memeber?(@current_user.id)
      ChapterMember.create({:memeber_type=>ChapterMember::MEMBER, :user_id => @current_user.id, :chapter_id => @chapter.id})
    end
    @profile_page = false
    #@members = @event.event_members
    respond_to do |format|
      format.js
    end
  end

  def new_agenda_and_speaker
    @speakers = @event.speakers
    @agenda = @event.agendas.new
    @existing_agenda = @event.agendas
  end

  def create_agenda
    @agenda = @event.agendas.new(params[:agenda])
    if @agenda.save!
      respond_to do |format|
        format.js
      end
    else
      render :new_agenda_and_speaker
    end

  end

  def agenda_delete
    if Agenda.delete(params[:agenda_id])
      respond_to do |format|
        format.js {render :nothing => true}
      end
    end
  end

  def update_agenda
    @agenda = Agenda.find(params[:agenda][:agenda_id]).update_attributes(:description => params[:agenda][:description])
    respond_to do |format|
      format.js {render :nothing => true}
    end
  end

  def add_speaker
    @event = Event.find(params[:id])
    @speaker = @event.add_or_create_speaker(params)
  end

  def speaker_delete
    #todo : FIXIT
    @speaker = @event.event_members.delete(@event.event_members.where(params[:speaker_id]).first)
    respond_to do |f|
      f.js { render nothing: true}
    end
  end


  # =>  Keeping it here....but dont understand what it is doing here....!!!!
  def download_list
    require 'csv'
    @event = Event.find(params[:id])
    @members = @event.event_members.includes(:user).collect{|i| i.user}
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

  private
  def set_profile_page
    @profile_page = true
  end

  def event
    @event = Event.find_by_id(params[:id])
  end

  def check_authorization
    if @current_user  and !@event.can_i_delete?(@current_user.id, @event.chapter_id)
      redirect_to event_path(@event)
    end
  end

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

end
