class ChangeChapterToFitCn < ActiveRecord::Migration
  def change
    remove_column :chapters, :institution

    add_column :chapters, :college_id, :integer
  end
end
