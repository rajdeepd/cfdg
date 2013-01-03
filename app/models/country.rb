class Country < ActiveRecord::Base
  # attr_accessible :title, :body
  has_many :states
  has_many :cities
end
