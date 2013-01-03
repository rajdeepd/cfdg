class PopulateCountriesStateCity < ActiveRecord::Migration

  def change
    `mysql -uroot -pwebonise6186 cf_usergroups < #{Rails.root.join("countries.sql")}`
    `mysql -uroot -pwebonise6186 cf_usergroups < #{Rails.root.join("states.sql")}`
    `mysql -uroot -pwebonise6186 cf_usergroups < #{Rails.root.join("cities.sql")}`
  end

end
