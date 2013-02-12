class AddDeviseFieldsToUsers < ActiveRecord::Migration
  def change
    add_column :users, :is_proprietary_user, :boolean
  end
end
