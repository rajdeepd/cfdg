class CreateEventGeolocations < ActiveRecord::Migration
  def change
    create_table :event_geolocations do |t|
      t.string :latitude
      t.string :longitude
      t.string :title
      t.integer :event_id

      t.timestamps
    end
  end
end
