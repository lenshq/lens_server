class CreateEvents < ActiveRecord::Migration
  def change
    create_table :events do |t|
      t.integer :page_id
      t.string :event_type
      t.text :content
      t.float :duration
      t.integer :position

      t.timestamps null: false
    end
  end
end
