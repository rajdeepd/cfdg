class Event < ActiveRecord::Base
  stampable
  acts_as_soft_deletable
  has_many :event_members
  has_many :users , :through => :event_members
  has_many :comments, :as => :commentable
  has_many :posts
  has_many :event_galleries, :dependent => :destroy
  belongs_to :chapter
  belongs_to :user , :foreign_key => :created_by
  attr_accessible :title, :description, :venue, :entry_fee, :chapter_id , :location,
                  :address_line1,   :address_line2 ,:start_time ,:end_time, :city_name, :postal_code, :state_name,
                  :country_name ,:agenda_and_speakers,:image,:attendees_count, :resources_request

  #mount_uploader :image, ImageUploader

  validates :title, :presence => true
  #validates :event_start_date ,:format => {
      #:with => /^([0-3])?[0-9]\/[0-1][0-9]\/[1-9][0-9][0-9][0-9]$/,
      #:message => "Date should be in dd/mm/yyyy format"
  #} , :unless => Proc.new{|event| event.event_start_date.blank?}

  #validates :event_end_date, :format => {
      #:with => /^([0-3])?[0-9]\/[0-1][0-9]\/[1-9][0-9][0-9][0-9]$/,
      #:message => "Date should be in dd/mm/yyyy format"
  #} , :unless => Proc.new{|event| event.event_end_date.blank?}

  scope :applied_events, where(:status => [:applied])
  scope :active_events, where(:status => [:active])
  scope :block_events, where(:status => [:blocked])

  state_machine :status, :initial => :applied do
    event :deny do
      transition :applied => :denied
    end

    event :approve do
      transition :applied => :active
    end

    event :block do
      transition :active => :blocked
    end

    event :unblock do
      transition :blocked => :active
    end
  end


  def <=> (other)
    other.start_time <=> self.start_time
  end

  def am_i_member?(user_id)
    self.event_members.where(:user_id => user_id).present?
  end

  def can_i_delete?(user_id, chapter_id)
    ChapterMember.am_i_coordinator?(user_id, chapter_id)
  end

  def schedule
    "#{I18n.l(self.start_time)} - #{I18n.l(self.end_time)}"
  end

  def location
    "#{self.chapter.location}#{self.address_line1}#{self.address_line2}"
  end

  def is_rsvp_allowed?

    # Commented by Larry. We don't need a people limit.

    #if  self.attendees_count.present?
      #self.event_members.length < self.attendees_count
    #else
      #true
    #end
  end
  
  def reservation_confirmed?(user)
    !EventMember.find_by_user_id_and_event_id(user.id, self.id).confirmed_at.nil?
  end

  def can_be_deleted?
    members = self.event_members.includes(:user)
    members.size == 1 and members.first.user.id == self.created_by
  end


  def is_cancelled?
    self.is_cancelled ? true : false
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
