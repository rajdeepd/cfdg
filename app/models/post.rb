class Post < ActiveRecord::Base
	acts_as_soft_deletable         
  	stampable	
	belongs_to :chapter
	belongs_to :event
	belongs_to :user , :foreign_key => :created_by
	attr_accessible :title, :description, :created_at, :chapter_id, :event_title, :event_id
  has_many :comments, :as => :commentable
	validates :title, :description , presence: true 
end
