class RemoveLocationInformationFromChapter < ActiveRecord::Migration
  def change
    remove_column :chapters, :country_id
    remove_column :chapters, :state_id
    remove_column :chapters, :country_name
    remove_column :chapters, :state_name
    remove_column :chapters, :city_name
  end
end
