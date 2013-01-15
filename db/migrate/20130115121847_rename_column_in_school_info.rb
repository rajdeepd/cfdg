class RenameColumnInSchoolInfo < ActiveRecord::Migration
  def change
    rename_column :school_infos, :other_school_name, :other_college_name
  end
end
