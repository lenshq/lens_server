class CreateApplications < ActiveRecord::Migration
  def change
    create_table :applications do |t|
      t.references :user, index: true, foreign_key: true
      t.string :title
      t.string :description
      t.string :domain
      t.string :token

      t.timestamps null: false
    end
  end
end
