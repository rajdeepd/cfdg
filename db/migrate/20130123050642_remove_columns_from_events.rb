class RemoveColumnsFromEvents < ActiveRecord::Migration
  def change
    remove_column :events, :location
    remove_column :events, :state_name
    remove_column :events, :country_name
  end
end
