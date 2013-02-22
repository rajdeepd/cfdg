class EventMediasController < ApplicationController

  before_filter :event
  respond_to :js, :html
  def index
    @event_videos = @event.event_medias.videos
  end

  def new
    @event_video = EventMedia.new
  end

  def create
    @media = @event.event_medias.create(params[:event_media])
  end

  def destroy
    @media = @event.event_medias.destroy(params[:id])
  end

  private
  def event
    @event = Event.find_by_id(params[:event_id])
  end

end