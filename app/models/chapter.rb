class Chapter < ActiveRecord::Base
  stampable
  after_create :persist_geocode
  acts_as_soft_deletable

  # Chapter Types
  CITY = :city
  STUDENT = :student

  has_many :chapter_members ,:dependent => :destroy

  has_many :messages
  accepts_nested_attributes_for :messages

  has_many :users , :through => :chapter_members
  has_many :events
  has_many :posts
  belongs_to :city
  belongs_to :user, :foreign_key => :created_by
  belongs_to :college

  has_one :geolocation
  # Setup accessible (or protected) attributes for your model
  attr_accessible :name, :chapter_type, :country_id , :state_id, :city_id , :locality, :address ,:landmark,:chapter_status, :country_name, :state_name, :city_name,:messages_attributes,:rejected_on , :approved_on,:institution, :chairman_photo, :chairman_description

  #validations
  validates  :chapter_type, presence: true, :inclusion => [CITY, STUDENT, CITY.to_s, STUDENT.to_s]
  validates_length_of :chairman_description, :maximum => 50, :message => "Not more than 50 words"
  
  #Scopes
  scope :applied_chapters, where(:chapter_status => [:applied, :incubated,:denied])
  scope :incubated_chapters, where(:chapter_status => :incubated)
  scope :active_chapters, where(:chapter_status => :active)
  scope :delist_chapters, where(:chapter_status => :delist)
  scope :incubated_or_active , where(:chapter_status => [:active,:incubated])
  scope :undenied , where(:chapter_status => [:applied, :active, :incubated, :delist])

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

  has_attached_file :chairman_photo,
    :styles => { :medium => "650x438>", :thumb => "128x90>" , :mini => "60x60>" },
    :path => ":class/:attachment/:id/:style/:filename"


  def is_type_student?
    self.chapter_type.to_sym == Chapter::STUDENT
  end

  def is_type_city?
    self.chapter_type.to_sym == Chapter::CITY
  end

  def self.find_chapter_for_user(user)
    chapters = { Chapter::CITY => [], Chapter::STUDENT => [] } 

    case user.role.to_sym
    when :professional, :fan
      chapters[Chapter::CITY] = user.city.chapters
    when :student
      chapters[Chapter::STUDENT] = user.college.try(:chapters)
      chapters[Chapter::CITY] = user.city.chapters
    end

    chapters
  end

  def location
    if self.is_type_student?
      self.college.name
    else
      self.city.detail
    end
  end

  def self.total_records
    { 
      Chapter::CITY => Chapter.where(:chapter_type => Chapter::CITY, :chapter_status => [:active,:incubated]),
      Chapter::STUDENT => Chapter.where(:chapter_type => Chapter::STUDENT, :chapter_status => [:active,:incubated])
    }
  end

  def am_i_chapter_memeber?(user_id)
    ChapterMember.find(:all , :conditions => [" user_id = ? and chapter_id = ? and memeber_type = ?", user_id, id,  ChapterMember::MEMBER]).present?
  end


  def get_all_members
     self.chapter_members.select{|i| i.memeber_type == ChapterMember::MEMBER}
  end
  
  def member_emails
    self.users.map(&:email)
  end

  def get_primary_coordinator
     User.find(self.created_by)
  end

  def is_primary_coordinator?(user)
    self.chapter_members.where(:user_id => user.id, :memeber_type => ChapterMember::PRIMARY_COORDINATOR).size > 0
  end

  def persist_geocode
    if self.is_type_student?
      college = self.college
      address = "#{college.state.country.name}#{college.state.name}#{college.name}" 
    else
      address = "#{self.city.state.country.name}#{self.city.detail}"
    end


    if(!address.blank?)
      begin
        options = Gmaps4rails.geocode(address)
        geotag= self.create_geolocation(:latitude => options.first[:lat], :longitude => options.first[:lng] , :title => options.first[:matched_address] )
      rescue Gmaps4rails::GeocodeStatus
      end
    end
  end

  def save_secondary_coordinator(member)
     #chapter_coordinator = self.chapter_members.create(:memeber_type => ChapterMember::SECONDARY_COORDINATOR, :user_id => user.id )
     chapter_coordinator = member
     chapter_coordinator.memeber_type =  ChapterMember::SECONDARY_COORDINATOR
     chapter_coordinator.save
  end

  def am_i_secondary_coordinator?(user)
    ChapterMember.where(" user_id = ? and chapter_id = ? and memeber_type = ?",user.id, self.id,  ChapterMember::SECONDARY_COORDINATOR).present?
  end

  def setup_with_user(user)
    if user.is_student?
      self.name = "CFDG - #{user.college.name}"
      self.chapter_type = Chapter::STUDENT
      self.college = user.college
    else
      self.name = "CFDG - #{user.city.name}"
      self.chapter_type = Chapter::CITY
      self.city = user.city
    end
  end
end
