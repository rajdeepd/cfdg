class User < ActiveRecord::Base

  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable,
  # :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :omniauthable#, :validatable 

  include Rails.application.routes.url_helpers
  
  #using the user stamp gem to populate created by, last modified by
  model_stamper
  acts_as_soft_deletable         
  stampable

  has_one :eventbrite_oauth_token
  has_many :chapter_members
  has_many :chapters , :through => :chapter_members
  has_many :events , :through => :event_members
  belongs_to :infoable, :polymorphic => true
  belongs_to :city

  ROLES = %w(professional student fan)
  
  

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :password_confirmation, :remember_me, :first_name, :last_name, :fullname,:mobile, :website_url, :linkedin_url, :twitter_url, 
                  :avatar, #:avatar_content_type, :avatar_file_name, :avatar_file_size, :avatar_updated_at,
                  :location, :admin, :profile_picture, :provider, :uid, :access_token, :expires_at, :refresh_token 

  attr_accessor :country, :state
#  has_attached_file :avatar,
#    :styles => { :medium => "157x161>", :thumb => "100x100>" },
#    :path => ":rails_root/public/system/:attachment/:id/:style/:filename",
#    :url => "/system/:attachment/:id/:style/:filename"

  has_attached_file :avatar, :styles => { :medium => "157x161>", :thumb => "100x100>" , :mini => "60x60>" }, :path => ":attachment/:id/:style/:filename"
  before_post_process :set_content_type

  def set_content_type
    self.avatar.instance_write(:content_type, MIME::Types.type_for(self.avatar_file_name).to_s)
  end

  def to_jq_upload
    binding.pry
    {
      "name" => read_attribute(:avatar_file_name),
      "size" => read_attribute(:avatar_file_size),
      "url" => avatar.url(:original),
      #"delete_url" => user_path(self),
      #"delete_type" => "DELETE" 
    }
  end

  def admin_user
    User.find_by_email("admin@cloudfoundry.com")
  end

  def self.find_for_auth(auth_data)
    user = User.find_by_provider_and_uid(auth_data[:provider], auth_data[:uid])
    
    if user
      user.update_attributes({ :access_token => auth_data[:access_token], :expires_at => auth_data[:expires_at], :refresh_token => auth_data[:refresh_token] })
    else
      user = User.new(auth_data.slice(:provider, :email, :uid, :access_token, :expires_at, :refresh_token).merge(:password => Devise.friendly_token[0,20]))
      user.save(:validate => false)
    end

    user
  end

  def is_professional
    self.role == 'professional'
  end

  def is_student
    self.role == 'student'
  end

  def is_fan
    self.role == 'fan'
  end
end
