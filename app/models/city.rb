class City < ActiveRecord::Base
  attr_accessible :name, :state_id, :detail 

  belongs_to :state
  has_many :users
  has_many :chapters
end
