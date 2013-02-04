class AddIsCancelledToEvents < ActiveRecord::Migration
  def change
    add_column :events, :is_cancelled, :boolean
  end
end
