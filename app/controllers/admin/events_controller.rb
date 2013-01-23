class Admin::EventsController < ApplicationController
  before_filter :admin_required
  before_filter :find_event, :only => [:approve, :block, :unblock, :deny]
  layout false

  def index
  end

  def all
    @events = Event.all
  end

  def applied_events
    @events = Event.applied_events
  end

  def active_events
    @events = Event.active_events
  end

  def block_events
    @events = Event.block_events
  end

# status change controller 
  def approve
    @event.approve

    respond_to do |format|
      format.js {render "remove_event"}
    end
  end

  def deny
    @event.deny

    respond_to do |format|
      format.js {render "remove_event"}
    end
  end

  def block
    @event.block

    respond_to do |format|
      format.js {render "remove_event"}
    end
  end

  def unblock
    @event.unblock

    respond_to do |format|
      format.js {render "remove_event"}
    end
    
  end

  private 
  def find_event
    @event = Event.find(params[:id])
  end
end
