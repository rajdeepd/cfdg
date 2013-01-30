class Agenda < ActiveRecord::Base

  belongs_to :event
  attr_accessible :description,:agenda_id

end
