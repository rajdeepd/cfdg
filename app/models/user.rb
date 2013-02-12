class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable,
  # :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable,:confirmable

  #using the user stamp gem to populate created by, last modified by
  model_stamper
  acts_as_soft_deletable
  stampable
  has_one :eventbrite_oauth_token
  has_many :chapter_members
  has_many :event_members
  has_many :chapters , :through => :chapter_members
  has_many :events , :through => :event_members
  scope :admin, where(:admin=> true).first
  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :description, :password, :password_confirmation, :remember_me, :first_name, :last_name, :fullname,:mobile, :website_url, :linkedin_url, :twitter_url, :avatar, :avatar_content_type,:location, :admin, :profile_picture,:reset_password_token,:is_proprietary_user
  #  has_attached_file :avatar,
  #    :styles => { :medium => "157x161>", :thumb => "100x100>" },
  #    :path => ":rails_root/public/system/:attachment/:id/:style/:filename",
  #    :url => "/system/:attachment/:id/:style/:filename"

  has_attached_file :avatar,
                    :styles => { :medium => "157x161>", :thumb => "100x100>" , :mini => "60x60>" },
                    :path => "/:attachment/:id/:style/:filename",
                    :storage => :s3,
                    :s3_credentials => "#{Rails.root}/config/s3.yml"

  scope :search, lambda {|user| where("fullname like ?", "%#{user}%").select("id, fullname as value")}

  def admin_user
    User.find_by_email("admin@cloudfoundry.com")
  end

  def change_reset_password_token
    reset_password_token =  nil
    save
  end

  def get_user_image
    if avatar?
      avatar_file_name
    else
      "no_image.jpg"
    end
  end

  def user_profile_completion_status
    status = false
    user_profile_status = 6
    user_profile_status -=  1 unless location?
    user_profile_status -= 1 unless avatar?
    user_profile_status -= 1 unless twitter_url?
    user_profile_status -= 1 unless linkedin_url?
    user_profile_status -= 1 unless  website_url?
    user_profile_status -= 1 unless email?
    status = true if user_profile_status == 6
    status
  end

  def get_user_past_events
    past_events = []
    user_all_events = events
    user_all_events.compact.each do |event|
      if((Time.parse(event.event_start_date+" "+event.event_start_time) < Time.now))
        past_events.push(event)
      end
    end
    past_events
  end

  def get_user_upcoming_events
    upcoming_events = []
      user_all_events =  events
      user_all_events.compact.each do |event|
        if((Time.parse(event.event_start_date+" "+event.event_start_time) >= Time.now))
          upcoming_events.push(event)
        end
      end
    upcoming_events
  end
  
end
