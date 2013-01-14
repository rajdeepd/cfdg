class Institution < ActiveRecord::Base
  attr_accessible :name, :college_id

  belongs_to :college
end
