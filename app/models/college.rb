class College < ActiveRecord::Base
  attr_accessible :name, :state_id, :renren_code
  
  has_many :school_infos
  belongs_to :state
  has_many :institutions
end
