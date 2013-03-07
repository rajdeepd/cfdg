class EventMedia < ActiveRecord::Base

  attr_accessible :url, :category, :event_id
  CATEGORIES = ["Video", "Slide"]
  validates :url, :presence => true
  belongs_to :event
  scope :videos, where(:category=>"Video")
  scope :slides, where(:category=>"Slide")

end
