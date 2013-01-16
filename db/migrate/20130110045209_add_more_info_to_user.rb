class AddMoreInfoToUser < ActiveRecord::Migration
  def change
    add_column :users, :access_token, :string
    add_column :users, :expires_at, :string
    add_column :users, :refresh_token, :string
  end
end