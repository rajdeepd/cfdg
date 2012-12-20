class CreateEventGalleries < ActiveRecord::Migration
  def change
    create_table :event_galleries do |t|
      t.string :image
      t.integer :event_id

      t.timestamps
    end
  end
end
