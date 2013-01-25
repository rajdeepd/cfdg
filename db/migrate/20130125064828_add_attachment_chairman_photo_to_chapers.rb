class AddAttachmentChairmanPhotoToChapers < ActiveRecord::Migration
  def self.up
    change_table :chapters do |t|
      t.attachment :chairman_photo
    end
  end

  def self.down
    drop_attached_file :chapters, :chairman_photo
  end
end
