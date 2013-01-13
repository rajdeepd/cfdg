class AddUserIdToInfos < ActiveRecord::Migration
  def change
    add_column :school_infos, :user_id, :integer
    add_column :company_infos, :user_id, :integer


    add_index :school_infos, :user_id
    add_index :company_infos, :user_id
  end
end
