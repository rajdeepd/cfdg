class AddInstitutionToChapter < ActiveRecord::Migration
  def change
    add_column :chapters, :institution, :string  ,:default => ""
  end
end
