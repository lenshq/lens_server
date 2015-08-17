class CreateRawEvents < ActiveRecord::Migration
  def change
    create_table :raw_events do |t|
      t.integer :application_id
      t.text :data
      t.string :state

      t.timestamps null: false
    end
  end
end
