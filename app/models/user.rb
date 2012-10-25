class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable,
  # :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  #using the user stamp gem to populate created by, last modified by
  model_stamper
  acts_as_soft_deletable         
  stampable
  has_one :eventbrite_oauth_token
  has_many :chapters , :through => :chapter_members
  has_many :events , :through => :event_members
  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :password_confirmation, :remember_me , :first_name, :last_name , :fullname,:mobile, :website_url, :linkedin_url, :twitter_url , :avatar , :avatar_content_type,:location , :admin
  has_attached_file :avatar,
    :styles => { :medium => "157x161>", :thumb => "100x100>" },
    :path => ":rails_root/public/system/:attachment/:id/:style/:filename",
    :url => "/system/:attachment/:id/:style/:filename"


  def admin_user
    User.find_by_email("admin@cloudfoundry.com")
  end
end
