class CreateAdminUsers < ActiveRecord::Migration
  def change
    add_column :users, :role, :string
    User.update_all(role: 'User')
  end
end
