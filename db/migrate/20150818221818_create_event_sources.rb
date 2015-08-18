class CreateEventSources < ActiveRecord::Migration
  def change
    create_table :event_sources do |t|
      t.integer :application_id
      t.string :source
      t.string :endpoint
      t.integer :pages_count

      t.timestamps null: false
    end
  end
end
