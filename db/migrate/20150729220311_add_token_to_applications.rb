class AddTokenToApplications < ActiveRecord::Migration
  def change
    add_column :applications, :token, :string, null: false

    add_index :applications, :token, unique: true
  end
end
