class City < ActiveRecord::Base
  # attr_accessible :title, :body
  belongs_to :state
  belongs_to :country
  attr_accessible :name
end
