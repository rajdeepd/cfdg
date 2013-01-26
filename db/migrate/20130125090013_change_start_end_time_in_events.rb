class ChangeStartEndTimeInEvents < ActiveRecord::Migration
  def change
    remove_column :events, :event_start_date
    remove_column :events, :event_end_date
    remove_column :events, :event_start_time
    remove_column :events, :event_end_time

    add_column :events, :start_time, :datetime
    add_column :events, :end_time, :datetime
  end
end
