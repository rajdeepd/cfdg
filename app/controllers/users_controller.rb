class UsersController < ApplicationController

  layout "chapters"

  before_filter :user, :only=> [:update]

  def edit
    @user = User.find_by_email(params[:email])
  end

  def update
    @user.update_attributes(params[:user])
    session[:user_id] = @user.id
    session[:user] = {:email => @user.email, :verified => true, :name => @user.fullname}
    redirect_to dashboard_user_path(@user)
  end

  def profile
    @user = @current_user
    @user_chapters = ChapterMember.get_chapters(@user.id) || []
    @create_event_from_chapters = params[:from]
    @chapter_id = params[:chapter_id]
    chapter_member = ChapterMember.get_details_if_coordinator(current_user.id).try(:first)
    @chapter = chapter_member.chapter if chapter_member
    @is_primary_coord = ChapterMember.is_primary_coordinator?(@user.id)
    @is_secondary_coord = ChapterMember.is_secondary_coordinator?(@user_id)
  end

  private
  def user
    @user = User.find_by_id(params[:id])
  end

end