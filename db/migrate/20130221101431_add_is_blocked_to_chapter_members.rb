class AddIsBlockedToChapterMembers < ActiveRecord::Migration
  def change
    add_column :chapter_members, :is_blocked, :boolean, :default => false
  end
end
