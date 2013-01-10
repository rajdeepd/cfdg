class CreateCompanyInfos < ActiveRecord::Migration
  def change
    create_table :company_infos do |t|
      t.string :company_name
      t.string :industry
      t.string :department
      t.string :title
      t.string :tel

      t.timestamps
    end
  end
end
