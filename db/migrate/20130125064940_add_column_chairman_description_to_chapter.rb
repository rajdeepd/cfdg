class AddColumnChairmanDescriptionToChapter < ActiveRecord::Migration
  def change
    add_column :chapters, :chairman_description, :text
  end
end
