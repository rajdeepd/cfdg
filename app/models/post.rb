class Post < ActiveRecord::Base
  include PublicActivity::Model
  tracked :owner=> proc {|controller, model| controller.current_user}
	acts_as_soft_deletable         
  stampable	
	belongs_to :chapter
	belongs_to :event
	belongs_to :user , :foreign_key => :created_by
  has_many :comments, :as => :commentable
	attr_accessible :title, :description, :created_at, :chapter_id, :event_title, :event_id
	validates :title, :description , presence: true 
end
