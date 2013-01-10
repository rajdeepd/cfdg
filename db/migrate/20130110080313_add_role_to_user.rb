class AddRoleToUser < ActiveRecord::Migration
  def change
    add_column :users, :role, :string, :length => 15
  end
end
