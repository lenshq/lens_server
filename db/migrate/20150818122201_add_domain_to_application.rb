class AddDomainToApplication < ActiveRecord::Migration
  def change
    add_column :applications, :domain, :string
  end
end
