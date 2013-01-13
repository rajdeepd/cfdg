class SchoolInfo < ActiveRecord::Base
  attr_accessible :graduated_at, :institution, :major, :school_name

  belongs_to :user
end
