class AddScenarioRefferenceToRawEvent < ActiveRecord::Migration
  def change
    add_column :raw_events, :scenario_id, :integer
  end
end
