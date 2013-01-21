class RemoveUnlessEventsField < ActiveRecord::Migration
  def change
    remove_column :events, :image, :venue, :city_name
  end
end
