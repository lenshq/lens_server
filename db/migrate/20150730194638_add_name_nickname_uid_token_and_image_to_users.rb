class AddNameNicknameUidTokenAndImageToUsers < ActiveRecord::Migration
  def change
    add_column :users, :name, :string
    add_column :users, :nickname, :string
    add_column :users, :image, :string
    add_column :users, :uid, :integer
    add_column :users, :token, :string
  end
end
