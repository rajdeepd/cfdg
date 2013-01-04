class PopulateCountriesStateCity < ActiveRecord::Migration

  def change
    `mysql -uroot -proot cf_usergroups_production < #{Rails.root.join("countries.sql")}`
    `mysql -uroot -proot cf_usergroups_production < #{Rails.root.join("states.sql")}`
    `mysql -uroot -proot cf_usergroups_production < #{Rails.root.join("cities.sql")}`
  end

end
