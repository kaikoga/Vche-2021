class CreateEventAppeals < ActiveRecord::Migration[6.1]
  def change
    create_table :event_appeals do |t|
      t.string :uid, null: :false, index: { unique: true }
      t.references :event, foreign_key: true, null: false
      t.references :user, foreign_key: true, null: true
      t.string :appeal_role
      t.boolean :available, null: false
      t.boolean :use_system_footer, null: false
      t.boolean :use_hashtag, null: false
      t.text :message
      t.text :message_before
      t.text :message_after

      t.references :created_user, foreign_key: { to_table: :users }
      t.references :updated_user, foreign_key: { to_table: :users }
      t.timestamps
    end
  end
end
