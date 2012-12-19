class EventGallery < ActiveRecord::Base

  belongs_to :event

  attr_accessible :image , :event_id
  mount_uploader :image, ImageUploader
end
