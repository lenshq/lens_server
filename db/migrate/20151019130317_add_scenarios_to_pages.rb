class AddScenariosToPages < ActiveRecord::Migration
  def change
    add_reference :pages, :scenario, index: true
  end
end
