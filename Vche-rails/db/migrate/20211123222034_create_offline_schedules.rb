class CreateOfflineSchedules < ActiveRecord::Migration[6.1]
  def change
    create_table :offline_schedules do |t|
      t.string :uid, null: :false, index: { unique: true }
      t.references :user
      t.string :name
      t.datetime :start_at, null: false
      t.datetime :end_at, null: false
      t.string :repeat
      t.datetime :repeat_until

      t.timestamps null: false
    end
  end
end
