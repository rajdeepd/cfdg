class AddSlideshowIdAndTitleToEventMedia < ActiveRecord::Migration
  def change
    add_column :event_media, :slideshow_id, :string
    add_column :event_media, :title, :string
  end
end
