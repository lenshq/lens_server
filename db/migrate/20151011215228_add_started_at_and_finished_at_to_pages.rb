class AddStartedAtAndFinishedAtToPages < ActiveRecord::Migration
  def change
    add_column :pages, :started_at, :float
    add_column :pages, :finished_at, :float
  end
end
