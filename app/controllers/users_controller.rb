class UsersController < ApplicationController
  layout 'chapters'
  before_filter "is_allowed_to_login" , :only => [:edit]

  def edit
    @user = User.find_by_email(params[:email])
    #binding.remote_pry
  end

  def update
    @user = User.find(params[:id])
    @user.update_attributes(params[:user])
    session[:user_id] = @user.id
    session[:user] = {:email => @user.email, :verified => true, :name => @user.fullname}
    redirect_to profile_url
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

  def settings
    @user = current_user
  end

  def settings_update
    current_user.update_attributes(params[:user])
    redirect_to  profile_url
  end

  def uploader
    @user = User.find(params[:id])
    @user.update_attributes(params[:user])
    mime_type = MIME::Types.type_for(@user.avatar_file_name)
    @user.update_attributes(:avatar_content_type => mime_type.first.content_type.to_s) if mime_type.first
    respond_to do |format|
      format.json { render json: @user.avatar.url(:medium)}
    end
  end


  def is_allowed_to_login
    can_login =  session[:is_allowed_to_login]
    session[:is_allowed_to_login] = nil
    redirect_to root_path unless can_login == true
  end

  def dashboard
    #@subscribed_chapter = []
    @upcoming_events = Event.get_upcoming_events
    #chapter_member = ChapterMember.find_all_by_user_id(@current_user)
    #chapter_member.each do |i|
    #  @subscribed_chapter.push(Chapter.find(i.chapter_id))
    #end
    @subscribed_chapter = ChapterMember.find_all_by_user_id(@current_user).collect{|i| i.chapter}
  end
end
