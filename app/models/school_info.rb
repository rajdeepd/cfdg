class SchoolInfo < ActiveRecord::Base
  attr_accessible :graduated_at, :institution, :major, :school_name

  has_one :user, :as => :infoable
end
