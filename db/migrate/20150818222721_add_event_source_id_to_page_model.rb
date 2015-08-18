class AddEventSourceIdToPageModel < ActiveRecord::Migration
  def change
    add_column :pages, :event_source_id, :integer
  end
end
