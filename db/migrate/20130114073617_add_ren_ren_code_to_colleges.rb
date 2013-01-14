class AddRenRenCodeToColleges < ActiveRecord::Migration
  def change
    add_column :colleges, :renren_code, :string
  end
end
