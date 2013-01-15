class RenameInsitutionColumnInSchoolInfo < ActiveRecord::Migration
  def change
    rename_column :school_infos, :other_institution, :other_institution_name
  end
end
