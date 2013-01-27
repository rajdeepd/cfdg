class EventMember < ActiveRecord::Base
acts_as_soft_deletable         
  stampable
  belongs_to :user
  belongs_to :event
  # Setup accessible (or protected) attributes for your model
  attr_accessible :event_id, :user_id, :confirmation_sent_at, :confirmation_token


  scope :confirmed, where("confirmed_at IS NOT NULL")

  def self.get_count(event_id)
    event_member = EventMember.find_all_by_event_id(event_id).count
    return event_member
  end

  def generate_confirmation!
    self.update_attributes(:confirmation_token => Devise.friendly_token[0..10],
                           :confirmation_sent_at => Time.now)
  end

  def confirm!
    self.update_attribute(:confirmed_at, Time.now)
  end
end
