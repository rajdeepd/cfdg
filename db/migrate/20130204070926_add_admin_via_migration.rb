class AddAdminViaMigration < ActiveRecord::Migration
  def change

    User.create(:email=>"admin@cloudfoundry.com",:fullname=>"Admin",:password=>"vmware123", :password_confirmation => "vmware123",:admin => true)

  end


end
