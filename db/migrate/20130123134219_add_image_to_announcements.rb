class AddImageToAnnouncements < ActiveRecord::Migration
  def change
    add_column :announcements, :image, :string
  end
end
