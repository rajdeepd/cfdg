class Event < ActiveRecord::Base
  stampable
  acts_as_soft_deletable
  after_create :persist_geocode

  %w(agendas event_members posts event_galleries).each do |assoc|
    has_many assoc.to_sym, :dependent=> :destroy
  end

  has_many :users , :through => :event_members
  has_many :comments, :as => :commentable
  has_one  :event_geolocation, :dependent => :destroy
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
  
  after_create :create_trigger
  after_update :update_trigger
  delegate :attendees, :members, :speakers, :to=> :event_members

  def self.build_hash
    country = []
    Chapter.all.each do |i|
      country.push(i.country_name)
    end
    country_count = country.uniq.count
    chapter_count = Chapter.all.length
    event_count = Event.all.length
    user_count = User.all.length
    upcoming_events = Event.get_upcoming_events
    return country, country_count, chapter_count, user_count, event_count, upcoming_events
  end

  # => 

  def create_trigger
    puts self.inspect
      start_date = (event_start_date?  and event_start_time?) ?   Time.parse(event_start_date + " " +event_start_time).strftime('%Y-%m-%d %H:%M:%S') : ""
      end_date = (event_end_date? and  event_end_time?) ? Time.parse(event_end_date + " " +event_end_time).strftime('%Y-%m-%d %H:%M:%S') : ""
      event_memeber = EventMember.new(:event_id => id, :user_id => (current_user.id rescue 1))
      event_memeber.save!
      to_email = chapter.get_primary_coordinator.email
      bcc_emails=chapter.chapter_members.includes.collect(&:user).collect(&:email) - [to_email]
      two_chapter_events = chapter.events.take(2)
      EventNotification.event_creation(self, to_email, bcc_emails, chapter).deliver
  end

  def update_trigger
    to_email = chapter.get_primary_coordinator.email
    bcc_emails = event_members.collect(&:user).collect(&:email) -[to_email]
    EventNotification.event_edit(self,to_email,bcc_emails,chapter).deliver
  end

  def <=> (other)
    if (other.event_start_date.blank? or  other.event_start_time.blank?)
      return 1
    elsif (self.event_start_date.blank? or  self.event_start_time.blank?)
      return 0
    end

    Time.parse(other.event_start_date + " " + other.event_start_time) <=> Time.parse(self.event_start_date + " " + self.event_start_time)
  end

  def build_show_hash
    emails = ''
    members = event_members.includes(:user).collect{|i| i.user}
    coordinaters = chapter.get_secondary_coordinators
    event_members.each do |member| 
      emails << (member.user.try(:email).to_s+"\;")  
    end
    if event_galleries.present?
      all_event_images =  event_galleries
    end
    marker = event_marker
    return emails, members, coordinaters, all_event_images, marker
  end

  def get_geocodes
    marker = []
    if geo_tag= event_geolocation
      marker << {:lat => geo_tag.latitude, :lng => geo_tag.longitude, :title => geo_tag.title}
    end
    marker
  end

  def event_marker
    get_geocodes.to_json
  end

  # => Move Mailer to Async way
  def cancel_event
    to_email = chapter.get_primary_coordinator.email
    bcc_emails = event_members.collect(&:user).collect(&:email) - [to_email]
    is_cancelled = true
    save
    EventNotification.event_cancellation(self, to_email, bcc_emails).deliver
  end

  def add_or_create_speaker(user)
    if user[:user]
      @user = User.find_by_fullname(user[:user])
    else
      @user = User.create!(user[:post].merge({:password=>"123456", :password_confirmation=>"123456"}))
    end
    speaker = false
    if @user && (!event_members.collect(&:user).include? @user)
      speaker = event_members.build(:user_id=> @user.id, :member_type=>"Speaker")
      speaker.save     
    end
    speaker.user rescue nil
  end

# => TODO:: Do we need these????

  def am_i_member?(user_id)
    event_members.where(:user_id => user_id).present?
  end

  def can_i_delete?(user_id, chapter_id)
    ChapterMember.am_i_coordinator?(user_id, chapter_id)
  end

  def is_rsvp_allowed?
    flag = true
    flag = event_members.length < attendees_count if attendees_count?
    flag
  end

  # => Check SA create event logic.....!!!
  def can_be_deleted?
    members.count == 1
  end

  # => TODO: update structure
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

  # => DELETE ME...!!
  def is_cancelled?
    self.is_cancelled ? true : false
  end

  # TODO: FIX ME
  def start_time_validation
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
    if chapter.geolocation
      geotag = create_event_geolocation(:latitude => chapter_geocode.latitude, :longitude => chapter_geocode.longitude , :title => chapter_geocode.title )
    end
  end

  # => TODO: DELETE me.
  # def self.search_events(query)
  #   where("city_name like ?", query)
  # end

  # Should be in user
  def event_created_by
    User.find_by_id(created_by)
  end


  def self.get_upcoming_events
    #self.all.select{|i| i.event_start_date_in_date < Date.today}
    upcoming_events = []
    all.each do |event|
      if(Time.parse(event.event_start_date+" "+ event.event_start_time) >= Time.now)
        upcoming_events.push(event)
      end

    end
    upcoming_events
  end



  def self.get_past_events
      #self.all.select{|i| i.event_start_date_in_date < Date.today}
      past_events = []
      all.each do |event|
        if(Time.parse(event.event_start_date+" "+ event.event_start_time) < Time.now)
          past_events.push(event)
        end

      end
      past_events
  end

  def self.search_event_chapter(query)
      chapters = []
      query_arr = query.split(",") if query
      if query_arr && query_arr.any?
        city,state,country = query_arr[0],query_arr[1],query_arr[2]
        chapters = Chapter.where(city_name: city.strip, state_name: state.strip, country_name: country.strip) if city && state && country
      end
      chapters.collect(&:events).flatten!
    end


  def get_event_image
    image || "logo-b.png"
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