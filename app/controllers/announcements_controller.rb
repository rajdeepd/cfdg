class AnnouncementsController < ApplicationController

  def show
    @announcement = Announcement.find(params[:id])
    @comments = @announcement.comments
  end

  def add_comment
    @announcement = Announcement.find(params[:comment][:commentable_id])
    @comment = Comment.new(params[:comment])
    @comments = @announcement.comments
    #@all_event_images = @event.event_galleries
    respond_to do |format|
      if(@comment.save)
        format.js
      end
    end
  end

end
