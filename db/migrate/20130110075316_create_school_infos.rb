class CreateSchoolInfos < ActiveRecord::Migration
  def change
    create_table :school_infos do |t|
      t.string :school_name
      t.string :institution
      t.string :major
      t.datetime :graduated_at

      t.timestamps
    end
  end
end
