class Admin::EventsController < ApplicationController
  before_filter :admin_required
  layout false

  def index
  end

  def all
    @events = Event.all
    render :layout => fasle 
  end

  def applied
    binding.pry
    @events = Event.applied_events
    render :layout => false
  end

  def active
    @events = Event.active_events
    render :layout => false
  end

  def freezed
    @events = Event.freezed_events
    render :layout => false
  end
end
