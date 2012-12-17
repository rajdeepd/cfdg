class AddAttendeesCountToEvent < ActiveRecord::Migration
  def change
    add_column :events, :attendees_count, :Integer
  end
end
