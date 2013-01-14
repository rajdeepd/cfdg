class SchoolInfo < ActiveRecord::Base
  attr_accessible :graduated_at, :major, :other_school_name, :other_insititution, :college_id, :institution_id

  belongs_to :user
  belongs_to :college
  belongs_to :institution
end
