class CreatePages < ActiveRecord::Migration
  def change
    create_table :pages do |t|
      t.integer :application_id
      t.string :controller
      t.string :action
      t.float :duration
      t.integer :events_count

      t.timestamps null: false
    end
  end
end
