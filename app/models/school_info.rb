class SchoolInfo < ActiveRecord::Base
  attr_accessible :graduated_at, :major, :other_college_name, :other_institution_name, :college_id, :institution_id

  belongs_to :user
  belongs_to :college
  belongs_to :institution
end
