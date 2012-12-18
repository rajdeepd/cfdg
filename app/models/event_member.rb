class EventMember < ActiveRecord::Base
acts_as_soft_deletable         
  stampable
  belongs_to :user
  belongs_to :event
  # Setup accessible (or protected) attributes for your model
  attr_accessible :event_id, :user_id

  def self.get_count(event_id)
    event_member = EventMember.find_all_by_event_id(event_id).count
    return event_member
  end
end
