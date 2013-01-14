class CreateColleges < ActiveRecord::Migration
  def change
    create_table :colleges do |t|
      t.string :name,     :length => 50
      t.integer :state_id

      t.timestamps
    end
  end
end
