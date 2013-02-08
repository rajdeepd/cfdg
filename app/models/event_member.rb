class EventMember < ActiveRecord::Base
acts_as_soft_deletable         
  stampable
  belongs_to :user
  belongs_to :event
  # Setup accessible (or protected) attributes for your model
  attr_accessible :event_id, :user_id, :member_type

  scope :speakers, lambda { where(:member_type=>"Speaker")}
  scope :attendees, lambda { where(:member_type=>"Attendee")}
  scope :members, all

  def self.get_count(event_id)
    find_all_by_event_id(event_id).count
  end
end
