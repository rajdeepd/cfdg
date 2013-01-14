class State < ActiveRecord::Base
  attr_accessible :name, :country_id
  has_many :cities
  belongs_to  :country
  has_many :colleges
end
