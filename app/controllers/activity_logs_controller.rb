class ActivityLogsController < ApplicationController
  # notifications_controller.rb

  def index
    @activities = PublicActivity::Activity.all
  end
end