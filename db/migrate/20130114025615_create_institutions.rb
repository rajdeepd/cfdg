class CreateInstitutions < ActiveRecord::Migration
  def change
    create_table :institutions do |t|
      t.string :name,  :length => 100
      t.integer :college_id
      t.timestamps
    end
  end
end
