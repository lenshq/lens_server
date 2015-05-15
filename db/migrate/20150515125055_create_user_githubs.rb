class CreateUserGithubs < ActiveRecord::Migration
  def change
    create_table :user_githubs do |t|
      t.references :user, index: true, foreign_key: true
      t.string :uid
      t.string :nickname
      t.string :email

      t.timestamps null: false
    end
  end
end
