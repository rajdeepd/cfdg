class EventGallery < ActiveRecord::Base

  belongs_to :event

  attr_accessible :image , :event_id,:Filename,:_http_accept, :authenticity_token, :_cloudfoundry_usergroups_session, :Filedata, :Upload, :action, :controller, :id,:format
  mount_uploader :image, ImageUploader
end
