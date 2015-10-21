class RenameTablePagesToRequests < ActiveRecord::Migration
  def change
    rename_table :pages, :requests
    rename_column :events, :page_id, :request_id
    rename_column :event_sources, :pages_count, :requests_count
  end
end
