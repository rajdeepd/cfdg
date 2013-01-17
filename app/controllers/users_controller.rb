class UsersController < ApplicationController
  layout 'chapters'

  before_filter :user_required!, :only => [:edit, :update, :avatar, :profile, :confirm]

  def edit
    @user = current_user

    @countries = Country.all
    @states = @countries.first.states

    @state = current_user.city.nil? ? @states.first : @user.city.state 
    @cities = @state.cities
    @city = current_user.city.nil? ? @cities.first : @user.city 


    @user.build_company_info unless @user.company_info
    @user.build_school_info unless @user.school_info
    
    @colleges = @state.colleges
    @college = @user.school_info.college.nil? ? @colleges.first : @user.school_info.college
    @institutions = @college.institutions
    @institution = @user.school_info.institution.nil? ? @institutions.first : @user.school_info.institution


    respond_to do |format|
      format.html
    end
  end

  def update

    @user = User.find(params[:id])

    attrs = params[:user]

    case attrs[:role]
    when "professional", "fan"
      attrs.slice!(:name, :email, :mobile, :city_id, :role, :company_info_attributes)
      @user.school_info.try(:destroy)
    when "student"
      attrs.slice!(:name, :email, :mobile, :city_id, :role, :school_info_attributes)

      attrs[:school_info_attributes][:college_id] = nil unless attrs[:school_info_attributes][:other_college_name].blank?
      attrs[:school_info_attributes][:institution_id] = nil unless attrs[:school_info_attributes][:other_institution_name].blank?

      @user.company_info.try(:destroy)
    end

    if @user.update_attributes(attrs)
      if @user.is_confirmed?
        redirect_to profile_url, :notice => "Your settings have been updated."
      else
        # sending confirmation email
        @user.generate_confirmation_token!
        UserMailer.confirmation_mail(@user).deliver

        respond_to do |format|
          format.html { render "email_confirmation_notice", :layout => "chapters" }
        end
      end
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

  def confirm
    @user = User.find_by_confirmation_token(params[:token])
    
    # if it is not timed out, 30 minutes.
    if Time.now.to_i - @user.confirmation_sent_at.to_i <= 1800

      # email address is confirmed
      @user.update_attribute(:confirmed_at, Time.now)

      sign_in_and_redirect @user, :event => :authentication
    else
      # send another
      
      @user.generate_confirmation_token! 
      UserMailer.confirmation_mail(@user).deliver 
      
      respond_to do |format|
        format.html { render "email_confirmation_notice", :layout => "chapters" }
      end
    end
  end
end
