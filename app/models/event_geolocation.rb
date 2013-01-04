class EventGeolocation < ActiveRecord::Base
  attr_accessible :event_id, :latitude, :longitude, :title
  belongs_to :event
end
