class Event < ActiveRecord::Base
  include PublicActivity::Model
  tracked :owner=> proc {|controller, model| controller.current_user}
  stampable

  acts_as_soft_deletable
  has_many :event_members
  has_many :users , :through => :event_members
  has_many :comments, :as => :commentable
  has_many :posts
  has_many :event_galleries, :dependent => :destroy
  belongs_to :chapter
  belongs_to :user , :foreign_key => :created_by
  attr_accessible :title, :event_start_date, :event_end_date, :status, :description, :venue, :entry_fee, :chapter_id , :location,
                  :address_line1,   :address_line2 ,:event_start_time,  :event_end_time, :city_name, :postal_code, :state_name,
                  :country_name ,:agenda_and_speakers,:image,:attendees_count
  mount_uploader :image, ImageUploader
  validate :start_time_validation
  validates :title,:event_start_time ,:event_start_date, :event_end_date, :event_end_time ,:presence => true
  validates :event_start_date ,:format => {
      :with => /^([0-3])?[0-9]\/[0-1][0-9]\/[1-9][0-9][0-9][0-9]$/,
      :message => "Date should be in dd/mm/yyyy format"
  } , :unless => Proc.new{|event| event.event_start_date.blank?}

  validates :event_end_date, :format => {
      :with => /^([0-3])?[0-9]\/[0-1][0-9]\/[1-9][0-9][0-9][0-9]$/,
      :message => "Date should be in dd/mm/yyyy format"
  } , :unless => Proc.new{|event| event.event_end_date.blank?}

  def <=> (other)
    if (other.event_start_date.blank? or  other.event_start_time.blank?)
      return 1
    elsif (self.event_start_date.blank? or  self.event_start_time.blank?)
      return 0
    end

    Time.parse(other.event_start_date + " " + other.event_start_time) <=> Time.parse(self.event_start_date + " " + self.event_start_time)
  end

  def onspot_registration params
    # user = User.new(params[:user].merge(:password=>"cloudfoundry", :password_confirmation=>"cloudfoundry"))
    user = User.find_by_email(params[:user][:email])
    user = User.new(params[:user].merge(:password=>"cloudfoundry", :password_confirmation=>"cloudfoundry")) unless user
    if user || user.save
      chapter.chapter_members.create(:memeber_type=>ChapterMember::MEMBER, :user_id => user.id) if !chapter.am_i_chapter_memeber?(user.id)
      if member = event_members.find_by_user_id(user.id)
        flag = false
      else
        member, flag = event_members.create(:user_id => user.id, :status=> true), true
      end
      EventNotification.user_registration_for_event(self,user).deliver
    end
    return member, flag, user
  end

  def update_attendee_status member_id
    member = event_members.find_by_user_id(member_id)
    member.update_attributes(:status=>!member.status)    
  end

  def am_i_member?(user_id)
    self.event_members.where(:user_id => user_id).present?
  end

  def can_i_delete?(user_id, chapter_id)
    ChapterMember.am_i_coordinator?(user_id, chapter_id)
  end

  def can_i_register?(user_id, chapter_id)
      ChapterMember.am_i_only_primary_coordinator?(user_id, chapter_id)
    end

  def is_rsvp_allowed?
    if  self.attendees_count.present?
      self.event_members.length < self.attendees_count
    else
      true
    end
  end

  def can_be_deleted?
    members = self.event_members.includes(:user)
    members.size == 1 and members.first.user.id == self.created_by
  end

  def event_start_date_in_date
    Date.parse(self.event_start_date)
  end

  def event_end_date_in_date
    Date.parse(self.event_end_date)
  end

  def event_end_time_in_time
    Time.parse(self.event_end_time)
  end

  def event_start_time_in_time
    Time.parse(self.event_start_time)
  end

  def is_cancelled?
    self.is_cancelled ? true : false
  end

  def start_time_validation
    #Rails.logger.info("date1  #{self.event_start_date_in_date}")
    #Rails.logger.info("date2  #{self.event_end_date_in_date}")
    #Rails.logger.info("time1  #{self.event_start_time_in_time}")
    #Rails.logger.info("time2  #{self.event_end_time_in_time}")
    #Rails.logger.info("time2class  #{self.event_end_time_in_time.class}")
    #Rails.logger.info("time2  #{self.event_end_time_in_time}")
    #Rails.logger.info("comparing")
    #Rails.logger.info("date  #{self.event_start_date_in_date >= self.event_end_date_in_date}")
    ##Rails.logger.info("time  #{self.event_start_time_in_time >= self.event_end_time_in_time}")
    #Rails.logger.info("time with now  #{self.event_start_time_in_time <= Time.now}")
    if  self.event_start_date_in_date >= self.event_end_date_in_date
      Rails.logger.info "date compared"
      if self.event_start_time_in_time >= self.event_end_time_in_time
        Rails.logger.info "Time Compared with now"
        Rails.logger.info "inside first comp"
        errors.add(:event_start_time, 'Event start time and end time are not valid')
      end
    end
    if self.event_start_date_in_date == Date.today
      if self.event_start_time_in_time <= Time.now
        Rails.logger.info "inside second comp"
        errors.add(:event_start_time, 'Event start time and end time are not valid') if !self.errors.messages[:event_start_time].present?
      end
    end
  end

  def is_past_event?
    if self.event_start_date_in_date < Date.today
      return true

    elsif self.event_start_date_in_date == Date.today
      if self.event_start_time_in_time < Time.now
        return true
      end
    else
      return false
    end
  end

end
