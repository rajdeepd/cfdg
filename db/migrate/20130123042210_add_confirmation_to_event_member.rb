class AddConfirmationToEventMember < ActiveRecord::Migration
  def change
    add_column :event_members, :confirmation_token, :string
    add_column :event_members, :confirmed_at, :datetime
    add_column :event_members, :confirmation_sent_at, :datetime
  end
end
