require 'net/http'
require 'uri'

class EventMediasController < ApplicationController

  protect_from_forgery :except => [:destroy]
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

  def event_slides
    @event_slides = @event.event_medias.slides
  end

  def new_slide
    @event_slide = EventMedia.new
  end

  def create_slide
    url = {:url => params[:event_media][:url]}
    create_slide = Net::HTTP.post_form(URI.parse("http://www.slideshare.net/api/oembed/2?url=#{params[:event_media][:url]}&format=json"), url)
    logger.info "#################{create_slide.body}"
    slideshow_body = JSON.parse(create_slide.body)
    @slide_id = slideshow_body['slideshow_id']
    @title = slideshow_body['title']
    @media = @event.event_medias.new(params[:event_media])
    @media.slideshow_id = @slide_id
    @media.title = @title
    @media.save!
  end

  private
  def event
    @event = Event.find_by_id(params[:event_id])
  end

end