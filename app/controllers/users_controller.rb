class UsersController < ApplicationController
  layout 'chapters'

  def edit
    @user = User.find_by_email(params[:email])
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
end
