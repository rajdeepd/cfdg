class CombineFirstLastNameToName < ActiveRecord::Migration
  def change
    remove_column :users, :first_name, :last_name
    add_column :users, :name, :string, :length => 20
  end
end
