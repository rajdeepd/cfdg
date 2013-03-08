class AddSlideshowImageToEventMedia < ActiveRecord::Migration
  def change
    add_column :event_media, :slideshow_image, :string
  end
end
