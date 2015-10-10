class AddStartAndFinishFiledsToEvntModel < ActiveRecord::Migration
  def change
    add_column :events, :started_at, :float
    add_column :events, :finished_at, :float
  end
end
