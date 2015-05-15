class CreateApplicationUsers < ActiveRecord::Migration
  def change
    create_table :application_users do |t|
      t.references :user, index: true, foreign_key: true
      t.references :application, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
