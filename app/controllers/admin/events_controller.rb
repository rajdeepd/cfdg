class Admin::EventsController < ApplicationController
  before_filter :admin_required
  layout 'admin'

  def index
    chapter = Chapter.find(params[:chapter_id])
    @events = chapter.events

  end

  def new
      chapter = Chapter.find(params[:chapter_id])
      @event = chapter.events.new
  end

  def create
    @event = Event.new(params[:event])
    respond_to do |format|
      if @event.save
        @event_memeber = EventMember.new(:event_id => @event.id, :user_id => @current_user.id)
        @event_memeber.save!
        @chapter = Chapter.find(@event.chapter_id)
        @chapter_events = @chapter.events.sort
        to_email = @chapter.get_primary_coordinator.email
        bcc_emails=@chapter.chapter_members.includes(:user).collect{|i| i.user.email} - [to_email]
        EventNotification.event_creation(@event,to_email,bcc_emails,@chapter).deliver
        redirect_to admin_chapter_event_path(params[:chapter_id],@event)
      else
        render :new
      end

    end

  end

  def show
    @event = Event.find(params[:id])
    @members = @event.event_members.includes(:user).collect{|i| i.user}

  end

  def edit
    @event = Event.find(params[:id])

  end

  def update
    @event = Event.find(params[:id])

    respond_to do |format|
      if @event.update_attributes(params[:event])
        format.html { redirect_to admin_chapter_event_path(params[:chapter_id],params[:id]), notice: 'Event was successfully updated.' }
        @chapter = Chapter.find(params[:chapter_id])
        logger.info("############## for admin ############{params[:send_email].inspect}")
        logger.info("################ for admin ##########{params[:send_email].class}")
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

  def destroy

  end


  def cancel_event
    event = Event.find(params[:id])
    chapter = event.chapter
    to_email = chapter.get_primary_coordinator.email
    bcc_emails = event.event_members.includes(:user).collect{|i| i.user.email} - [to_email]
    event.is_cancelled = true
    event.save
    #EventNotification.delay.event_cancellation(@event, emails)
    EventNotification.event_cancellation(event,to_email,bcc_emails).deliver
    #SES.send_raw_email(EventNotification.event_cancellation(@event,to_email,bcc_emails))
    #chapter_events = Event.find_all_by_chapter_id(event.chapter_id) || []
    #get_upcoming_and_past_events(chapter_events, true)
    #@profile_page = false
    redirect_to admin_chapter_events_path(params[:chapter_id])
  end

end