class Event < ActiveRecord::Base
  stampable
  acts_as_soft_deletable
  after_create :persist_geocode
  has_many :event_members
  has_many :users , :through => :event_members
  has_many :comments, :as => :commentable
  has_many :posts
  has_many :event_galleries, :dependent => :destroy
  has_one  :event_geolocation
  belongs_to :chapter
  belongs_to :user , :foreign_key => :created_by
  attr_accessible :title, :event_start_date, :event_end_date, :status, :description, :venue, :entry_fee, :chapter_id , :location,
                  :address_line1,   :address_line2 ,:event_start_time ,:event_end_time, :city_name, :postal_code, :state_name,
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

  def am_i_member?(user_id)
    self.event_members.where(:user_id => user_id).present?
  end

  def can_i_delete?(user_id, chapter_id)
    ChapterMember.am_i_coordinator?(user_id, chapter_id)
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
    ##Rails.logger.info("time  #{self.event_start_time_in_time >= self.event_end_time_in_time}")                 city
    #Rails.logger.info("time with now  #{self.event_start_time_in_time <= Time.now}")
    if  self.event_start_date_in_date >= self.event_end_date_in_date
      Rails.logger.info "date compared"
      if self.event_start_time_in_time >= self.event_end_time_in_time
        Rails.logger.info "Time Compared with now"
        Rails.logger.info "inside first comp"
        errors.add(:event_start_time, 'is not valid')
      end
    end
    if self.event_start_date_in_date == Date.today
      if self.event_start_time_in_time <= Time.now
        Rails.logger.info "inside second comp"
        errors.add(:event_start_time, 'is not valid') if !self.errors.messages[:event_start_time].present?
      end
    end
  end


  def persist_geocode
    logger.info "inside persist geocode"
    chapter_geocode = self.chapter.geolocation
    if chapter_geocode.present?
      geotag = self.create_event_geolocation(:latitude => chapter_geocode.latitude, :longitude => chapter_geocode.longitude , :title => chapter_geocode.title )
    end
  end

  def self.search_events(query)
    where("city_name like ?", query)
  end

  def event_created_by
    User.find(self.created_by)
  end


  def self.get_upcoming_events
    #self.all.select{|i| i.event_start_date_in_date < Date.today}
    upcoming_events = []
    Event.all.each do |event|
      if(Time.parse(event.event_start_date+" "+ event.event_start_time) >= Time.now)
        upcoming_events.push(event)
      end

    end
    upcoming_events
  end



  def self.get_past_events
      #self.all.select{|i| i.event_start_date_in_date < Date.today}
      past_events = []
      Event.all.each do |event|
        if(Time.parse(event.event_start_date+" "+ event.event_start_time) < Time.now)
          past_events.push(event)
        end

      end
      past_events
  end

  def self.search_event_chapter(query)
      chapters = []
      events = []
      query_arr = query.split(",") if query.present?
      if query_arr.present?
        city = query_arr[0]
        state= query_arr[1]
        country = query_arr[2]
        #chapters=where("city_name like ? and state_name like ? and country_name like ?", city.strip,state.strip,country.strip) if city.present? and state.present? and country.present?
        chapters = Chapter.where("city_name like ? and state_name like ? and country_name like ?", city.strip,state.strip,country.strip) if city.present? and state.present? and country.present?
      end
      chapters.to_a.each do |i|
        puts i.class
        events.push(i.events)
      end
    events.flatten!
    end


  def get_event_image
    if self.image.present?
      self.image
    else
      "logo-b.png"
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

  def get_country_for_city(event)
    city = event.city_name
    city_details = City.find_by_name(city)
    country = Country.find(city_details.country_id)
    return country.name
  end

end