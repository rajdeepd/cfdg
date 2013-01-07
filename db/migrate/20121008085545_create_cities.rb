class CreateCities < ActiveRecord::Migration
  def change
    create_table :cities do |t|
      t.string  :name
      t.integer  :state_id
   	  t.integer :created_by
      t.integer :updated_by
      t.datetime :deleted_at	
      t.timestamps
    end
  end
end
