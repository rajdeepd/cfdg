class User < ActiveRecord::Base

  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable,
  # :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable, :recoverable, :rememberable, :trackable, :omniauthable

  include Rails.application.routes.url_helpers
  
  #using the user stamp gem to populate created by, last modified by
  model_stamper
  acts_as_soft_deletable         
  stampable

  has_one :eventbrite_oauth_token
  has_many :chapter_members
  has_many :chapters , :through => :chapter_members
  has_many :events , :through => :event_members
  belongs_to :city
  
  has_one :company_info
  has_one :school_info

  accepts_nested_attributes_for :company_info, :school_info

  ROLES = %w(professional student fan)

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :password_confirmation, :remember_me, :name, :mobile, :website_url, :linkedin_url, :twitter_url, 
                  :avatar, :company_info_attributes, :school_info_attributes, :city_id, :role, :confirmation_token, :confirmation_sent_at,
                  :location, :admin, :profile_picture, :provider, :uid, :access_token, :expires_at, :refresh_token 

  attr_accessor :state


  has_attached_file :avatar, 
    :styles => { :medium => "157x161>", :thumb => "100x100>" , :mini => "60x60>" }, 
    :path => ":attachment/:id/:style/:filename"


  # Validations
  validates :name, :presence => true
  validates :email, :presence => true, :format => { :with => /^([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})$/i, :message => I18n.t("errors.messages.invalid_email") }
  validates :mobile, :presence => true

  validates_associated :company_info, :if => "role == 'professional' || role == 'role'"
  validates_associated :school_info, :if => "role == 'student'"

  def is_confirmed?
    !self.confirmed_at.nil?
  end

  def generate_confirmation_token!
    self.update_attributes!(:confirmation_token => Devise.friendly_token[0..8], :confirmation_sent_at => Time.now)
  end

  def self.admin_user
    #User.find_by_email("admin@cloudfoundry.com")
    User.find_by_admin(true)
  end

  def self.non_admin_all
    User.where(:admin => false)
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

  def is_professional?
    self.role == 'professional'
  end

  def is_student?
    self.role == 'student'
  end

  def is_fan?
    self.role == 'fan'
  end

  def college
    self.try(:school_info).college
  end

  def self.all_receivers
    User.non_admin_all.map(&:email)
  end
end
