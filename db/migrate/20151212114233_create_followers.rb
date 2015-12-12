class CreateFollowers < ActiveRecord::Migration
  def change
    create_table :followers do |t|
      t.string :email, null: false
      t.string :name
      t.string :reason

      t.timestamps
    end

    add_index :followers, :email, unique: true
  end
end
