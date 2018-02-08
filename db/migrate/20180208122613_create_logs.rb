class CreateLogs < ActiveRecord::Migration[5.1]
  def change
    create_table :logs do |t|
      t.string :event_type
      t.integer :event_xid
      t.string :username
      t.json :data

      t.timestamps
    end
  end
end
