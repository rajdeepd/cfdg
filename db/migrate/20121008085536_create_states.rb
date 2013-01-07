class CreateStates < ActiveRecord::Migration
  def change
    create_table :states do |t|
      t.string  :name
      t.integer  :country_id
   	  t.integer :created_by
      t.integer :updated_by
      t.datetime :deleted_at	
      t.timestamps
    end
  end
end
