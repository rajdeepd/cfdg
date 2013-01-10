class AddInfoableToUser < ActiveRecord::Migration
  def change
    add_column :users, :infoable_type, :string, :length => 15
    add_column :users, :infoable_id, :integer
    
    add_index :users, [:infoable_type, :infoable_id], :unique => true
  end
end
