class CompanyInfo < ActiveRecord::Base
  attr_accessible :company_name, :department, :industry, :tel, :title

  belongs_to :user

  validates :company_name, :presence => true
  validates :industry, :presence => true
end
