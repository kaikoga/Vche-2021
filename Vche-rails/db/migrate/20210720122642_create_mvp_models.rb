class CreateMvpModels < ActiveRecord::Migration[6.1]
  def change
    add_column :users, :uid, :string, null: false, after: :email
    add_column :users, :display_name, :string, after: :uid, default: nil
    add_column :users, :visibility, :string, null: false, after: :display_name
    add_column :users, :trust, :integer, null: false, after: :visibility
    add_column :users, :user_role, :string, null: false, after: :trust
    add_column :users, :admin_role, :string, null: false, after: :user_role

    add_index :users, :uid, unique: true

    create_table :accounts do |t|
      t.string :uid, null: :false
      t.string :name, null: :false
      t.string :display_name, null: :false
      t.string :platform, null: :false
      t.string :url
      t.references :user, foreign_key: true, null: false

      t.timestamps null: false
    end

    create_table :events do |t|
      t.string :uid, null: :false
      t.string :name, null: :false
      t.string :hashtag
      t.string :platform
      t.string :visibility
      t.integer :trust

      t.references :created_user, foreign_key: { to_table: :users }
      t.references :updated_user, foreign_key: { to_table: :users }
      t.timestamps null: false
    end

    create_table :event_schedules do |t|
      t.string :uid, null: :false
      t.references :event, foreign_key: true, null: false
      t.string :visibility
      t.datetime :assemble_at
      t.datetime :open_at
      t.datetime :start_at, null: false
      t.datetime :end_at, null: false
      t.datetime :close_at
      t.json :repeat
      t.datetime :repeat_until

      t.references :created_user, foreign_key: { to_table: :users }
      t.references :updated_user, foreign_key: { to_table: :users }
      t.timestamps null: false
    end

    create_table :event_histories do |t|
      t.string :uid, null: :false
      t.references :event, foreign_key: true, null: false
      t.string :visibility
      t.string :resolution
      t.datetime :assembled_at
      t.datetime :opened_at
      t.datetime :started_at, null: false
      t.datetime :ended_at, null: false
      t.datetime :closed_at

      t.timestamps null: false
    end

    create_table :hashtag_follows do |t|
      t.references :user, foreign_key: true, null: false
      t.string :hashtag
      t.string :role, null: :false

      t.timestamps null: false
    end

    create_table :event_follows do |t|
      t.references :user, foreign_key: true, null: false
      t.references :event, foreign_key: true, null: false
      t.string :role, null: :false

      t.timestamps null: false
    end

    create_table :event_attendances do |t|
      t.string :uid, null: :false
      t.references :user, foreign_key: true, null: false
      t.references :event, foreign_key: true, null: false
      t.datetime :started_at, null: false
      t.string :role, null: :false
      t.string :hashtag

      t.timestamps null: false
    end

    add_index :accounts, :uid, unique: true
    add_index :events, :uid, unique: true
    add_index :events, :hashtag, unique: true
    add_index :event_schedules, :uid, unique: true
    add_index :event_histories, :uid, unique: true
    add_index :event_attendances, :uid, unique: true
    add_index :event_attendances, [:user_id, :event_id, :started_at], unique: true
  end
end
