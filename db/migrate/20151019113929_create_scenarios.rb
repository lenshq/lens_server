class CreateScenarios < ActiveRecord::Migration
  def change
    create_table :scenarios do |t|
      t.timestamps null: false
      t.string :events_hash
      t.references :event_source, index: true
    end
  end
end
