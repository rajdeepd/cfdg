class AddStatusToEventMembers < ActiveRecord::Migration
  def change
    add_column :event_members, :status, :boolean
  end
end
