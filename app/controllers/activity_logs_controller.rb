class ActivityLogsController < ApplicationController
  # notifications_controller.rb

  def index
    @activities = PublicActivity::Activity.page(params[:page] || 1).order("created_at DESC").per(20)
    render :layout=>false
  end

end
