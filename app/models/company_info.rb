class CompanyInfo < ActiveRecord::Base
  attr_accessible :company_name, :department, :industry, :tel, :title

  has_one :user, :as => :infoable
end
