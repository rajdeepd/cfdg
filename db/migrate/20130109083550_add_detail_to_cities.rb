class AddDetailToCities < ActiveRecord::Migration
  def change
    add_column :cities, :detail, :string
  end
end
