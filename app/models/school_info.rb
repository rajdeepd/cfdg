class SchoolInfo < ActiveRecord::Base
  attr_accessible :graduated_at, :major, :other_college_name, :other_institution_name, :college_id, :institution_id

  belongs_to :user
  belongs_to :college
  belongs_to :institution

  validates :other_college_name, :presence => true, :if => "college_id == nil"
  validates :industry, :presence => true, :if => "institution_id == nil || college_id == nil"
  validates :graduated_at, :presence => true 
end
