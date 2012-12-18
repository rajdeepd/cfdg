class CreateGeolocations < ActiveRecord::Migration
  def change
    create_table :geolocations do |t|
      t.string :latitude
      t.string :longitude
      t.string :title
      t.integer :chapter_id

      t.timestamps
    end
  end
end
