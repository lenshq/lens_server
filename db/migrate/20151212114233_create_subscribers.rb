class CreateSubscribers < ActiveRecord::Migration
  def change
    create_table :subscribers do |t|
      t.string :email, null: false
      t.string :name
      t.string :reason
      t.string :aasm_state, null: false
      t.string :verification_token, null: false
      t.string :unsubscription_token, null: false

      t.timestamps
    end

    add_index :subscribers, :email, unique: true
    add_index :subscribers, :verification_token, unique: true
    add_index :subscribers, :unsubscription_token, unique: true
  end
end
