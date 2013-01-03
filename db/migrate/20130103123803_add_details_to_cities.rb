class AddDetailsToCities < ActiveRecord::Migration
  def change
    add_column :cities, :details, :string
  end
end
