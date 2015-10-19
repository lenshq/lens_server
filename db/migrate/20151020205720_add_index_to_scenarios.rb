class AddIndexToScenarios < ActiveRecord::Migration
  def change
    add_index :scenarios, [:events_hash, :event_source_id], unique: true
  end
end
