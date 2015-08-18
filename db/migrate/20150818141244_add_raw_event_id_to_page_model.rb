class AddRawEventIdToPageModel < ActiveRecord::Migration
  def change
    add_column :pages, :raw_event_id, :integer
  end
end
