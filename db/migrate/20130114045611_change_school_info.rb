class ChangeSchoolInfo < ActiveRecord::Migration
  def change
    rename_column :school_infos, :school_name, :other_school_name
    rename_column :school_infos, :institution, :other_institution

    add_column :school_infos, :college_id, :integer
    add_column :school_infos, :institution_id, :integer
  end
end
