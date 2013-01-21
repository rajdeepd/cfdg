# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

#User.create(:email=>"siteadmin@gmail.com",:fullname=>"SiteAdmin",:password=>"admincloud", :password_confirmation => "admincloud",:admin => true)


User.create(:email=>"admin@cloudfoundry.com",:name => "Admin", :password => "vmware123", :password_confirmation => "vmware123",:admin => true, :mobile => "18602196197")
