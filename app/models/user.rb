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
  has_many :providers
  has_many :chapters , :through => :chapter_members
  has_many :events , :through => :event_members
  validates :email, :presence => true, :uniqueness => true
  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :password_confirmation, :remember_me, :first_name, :last_name, :fullname,:mobile, :website_url, :linkedin_url, :twitter_url, :avatar, :avatar_content_type,:location, :admin, :profile_picture,:reset_password_token,:is_proprietary_user
  #  has_attached_file :avatar,
  #    :styles => { :medium => "157x161>", :thumb => "100x100>" },
  #    :path => ":rails_root/public/system/:attachment/:id/:style/:filename",
  #    :url => "/system/:attachment/:id/:style/:filename"

  has_attached_file :avatar,
                    :styles => { :medium => "157x161>", :thumb => "100x100>" , :mini => "60x60>" },
                    :path => "/:attachment/:id/:style/:filename",
                    :storage => :s3,
                    :s3_credentials => "#{Rails.root}/config/s3.yml"

  def admin_user
    User.find_by_email("admin@cloudfoundry.com")
  end

  def change_reset_password_token
    Rails.logger.info "RESET PASSWORD TOKEN MAKING Nil"
    Rails.logger.info self.reset_password_token.inspect
    Rails.logger.info self.inspect
    self.reset_password_token =  nil
    self.save
    Rails.logger.info self.reset_password_token.inspect
    Rails.logger.info self.inspect
  end

  def self.create_outh_auth_user(hash)
    token_array =  [('a'..'z'),('A'..'Z'),(0..9)].map{|i| i.to_a}.flatten
    new_reset_token = (0...20).map{ token_array[rand(token_array.length)] }.join
    if User.all.any?{|i| i.reset_password_token == new_reset_token}
    else
      user = User.new(:email => hash['info']['email'],:fullname => hash['info']['name'],:admin => false,:reset_password_token => new_reset_token)
      if user.save!(:validate => false)
        provider = user.providers.create(:provider => hash['provider'],:uid => hash['uid'])
        provider.save!
      end
    end
    return user
  end

end
