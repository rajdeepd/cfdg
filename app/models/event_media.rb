class EventMedia < ActiveRecord::Base

  attr_accessible :url, :category, :event_id

  CATEGORIES = ["Video", "Slide"]

  validates :url, :presence=> true

  scope :videos, where(:category=>"Video")

end
