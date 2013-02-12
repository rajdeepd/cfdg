class AddEventMembersToEventsMembers < ActiveRecord::Migration
  def change
  	add_column :event_members, :member_type, :string
  end
end
