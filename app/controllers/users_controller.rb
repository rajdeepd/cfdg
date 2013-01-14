class UsersController < ApplicationController
  layout 'chapters'

  def index
    respond_to do |format|
      format.json { render json: @uploads.map{|upload| upload.to_jq_upload } }
    end
  end

  def new
    binding.pry
    @countries = Country.all
    @states = @countries.first.states
    @cities = @states.first.cities

    @user = User.new
  end

  def edit
    @user = current_user
    
    @countries = Country.all
    @states = @countries.first.states
    @cities = @states.first.cities

    @colleges = @states.first.colleges
    @institutions = @colleges.first.institutions
    
    @user.build_company_info unless @user.company_info
    @user.build_school_info unless @user.school_info
  end

  def update
    @user = User.find(params[:id])
    
    attrs = params[:user]
    
    case attrs[:role]
    when "professional", "fan"
      attrs.slice!(:last_name, :first_name, :email, :mobile, :city_id, :role, :company_info_attributes)
    when "student"
      attrs.slice!(:last_name, :first_name, :email, :mobile, :city_id, :role, :school_info_attributes)
    end

    if @user.update_attributes(attrs)
      redirect_to profile_url
    else

    end
  end

  # Receives the avatar upload 
  def avatar
    @user = current_user
    
    respond_to do |format|
      if @user.update_attributes(params[:user].slice(:avatar))
        format.json { render json: [@user.avatar.url(:medium)], status: :created, location: @user }
      else
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  def profile
    @user = current_user
    @user_chapters = ChapterMember.get_chapters(@user.id) || []
    @create_event_from_chapters = params[:from]
    @chapter_id = params[:chapter_id]
    chapter_member = ChapterMember.get_details_if_coordinator(current_user.id).try(:first)
    @chapter = chapter_member.chapter if chapter_member
    @is_primary_coord = ChapterMember.is_primary_coordinator?(@user.id)
    @is_secondary_coord = ChapterMember.is_secondary_coordinator?(@user_id)
  end
end
