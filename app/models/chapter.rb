class Chapter < ActiveRecord::Base
  stampable
  after_create :persist_geocode
  acts_as_soft_deletable


  has_many :chapter_members ,:dependent => :destroy

  has_many :messages
  accepts_nested_attributes_for :messages
  has_many :users , :through => :chapter_members
  has_many :events
  has_many :posts
  belongs_to :country
  belongs_to :state
  belongs_to :city
  belongs_to :user, :foreign_key => :created_by
  has_one :geolocation
  # Setup accessible (or protected) attributes for your model
  attr_accessible :name, :chapter_type, :country_id , :state_id, :city_id , :locality, :address ,:landmark,:chapter_status, :country_name, :state_name, :city_name,:messages_attributes,:rejected_on , :approved_on,:institution

  #validations
  validates  :country_id , :state_id, :city_id,:country_name, :state_name, :city_name,:chapter_type, presence: true
  validates :locality, :address ,:landmark, presence: true , :if => lambda { |o| o.chapter_type == "student"}
  validates_uniqueness_of :city_name, :scope => [:state_name , :country_name], :if => lambda { |o| o.chapter_type == "professional"}
  validates_with CityNameValidator
  #Scopes
  scope :applied_chapters, where(:chapter_status => [:applied, :incubated,:denied])
  scope :incubated_chapters, where(:chapter_status => :incubated)
  scope :active_chapters, where(:chapter_status => :active)
  scope :delist_chapters, where(:chapter_status => :delist)
  scope :incubated_or_active , where(:chapter_status => [:active,:incubated])

  state_machine :chapter_status, :initial => :applied do

    # The first transition that matches the status and passes its conditions
    event :deny do
      transition :applied => :denied
    end

    event :incubate do
      transition :applied => :incubated
    end

    event :active do
      transition :incubated => :active
    end

    event :delist do
      transition :incubated => :delist
    end

    event :active_to_incubate do
      transition :active => :incubated
    end

    event :delist_to_incubate do
      transition :delist => :incubated
    end

  end

  def location
    location = city_name
    location += "," + state_name if !state_name.blank?
    location += "," + country_name if !country_name.blank?
  end

  def self.total_records
    Chapter.select('country_name').group('country_name').where(:chapter_status => [:active,:incubated])
  end

  def am_i_chapter_memeber?(user_id)
    ChapterMember.find(:all , :conditions => [" user_id = ? and chapter_id = ? and memeber_type = ?", user_id, id,  ChapterMember::MEMBER]).present?
  end

  def get_primary_coordinator
    User.find(self.created_by)
  end

  def persist_geocode
    logger.info "inside persist geocode"
    city = self.city_name.blank? ? "" : self.city_name + ","
    state = self.state_name.blank? ? "" : self.state_name + ","
    country = self.country_name.blank? ? "" : self.country_name
    address=city + state + country
    if(!address.blank?)
      begin
        options = Gmaps4rails.geocode(address)
        geotag= self.create_geolocation(:latitude => options.first[:lat], :longitude => options.first[:lng] , :title => options.first[:matched_address] )
      rescue Gmaps4rails::GeocodeStatus
      end
    end
  end

  def self.search_chapters(query)
    query_arr = query.split(",")
    puts query_arr.inspect
    puts query_arr.length
    city = query_arr[0]
    state= query_arr[1]
    country = query_arr[2]
    where("city_name like ? and state_name like ? and country_name like ?", city.strip,state.strip,country.strip)
  end

  def self.create_new_chapter(param,chapter_name)
    country = Country.find(param[:chapter][:country_name])
    state = State.find(param[:chapter_state_name])
    city = City.find(param[:chapter_city_name])
    chapter = Chapter.new(:name => chapter_name,:chapter_type => param[:chapter][:chapter_type],:country_id => country.id,:state_id => state.id,
                          :city_id => city.id,:locality => param[:chapter][:locality],:address => param[:chapter][:address],:landmark => param[:chapter][:landmark],
                          :institution => param[:chapter][:institution],:city_name => city.name.strip,
                          :state_name => state.name.strip,:country_name => country.name.strip)
    chapter.save!
    return chapter
  end
end
