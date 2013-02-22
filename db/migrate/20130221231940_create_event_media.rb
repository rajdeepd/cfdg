class CreateEventMedia < ActiveRecord::Migration
  def change
    create_table :event_media do |t|
      t.string :url, :category
      t.belongs_to :event
      t.timestamps
    end
  end
end