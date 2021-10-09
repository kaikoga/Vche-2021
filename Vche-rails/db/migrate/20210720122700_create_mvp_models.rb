class CreateMvpModels < ActiveRecord::Migration[6.1]
  def change
    create_table :platforms do |t|
      t.string :slug, null: :false, index: { unique: true }
      t.string :name, null: :false, index: { unique: true }
      t.boolean :available, null: :false

      t.timestamps null: false
    end

    create_table :categories do |t|
      t.string :emoji, null: :false, index: { unique: true }
      t.string :slug, null: :false, index: { unique: true }
      t.string :name, null: :false, index: { unique: true }
      t.boolean :available, null: :false

      t.timestamps null: false
    end

    create_table :flavors do |t|
      t.string :emoji, null: :false, index: { unique: true }
      t.string :slug, null: :false, index: { unique: true }
      t.string :name, null: :false, index: { unique: true }
      t.string :taste, null: :false
      t.boolean :available, null: :false

      t.timestamps null: false
    end

    add_column :users, :uid, :string, null: false, after: :email, index: { unique: true }
    add_column :users, :display_name, :string, after: :uid
    add_column :users, :primary_sns, :string, after: :display_name
    add_column :users, :profile, :string, after: :primary_sns
    add_column :users, :visibility, :string, null: false, after: :profile
    add_column :users, :trust, :integer, null: false, after: :visibility
    add_column :users, :user_role, :string, null: false, after: :trust
    add_column :users, :admin_role, :string, null: false, after: :user_role
    add_column :users, :agreed_at, :datetime, after: :admin_role

    create_table :accounts do |t|
      t.string :uid, null: :false, index: { unique: true }
      t.string :name, null: :false
      t.string :display_name, null: :false
      t.references :platform, { foreign_key: true, null: false}
      t.string :url
      t.references :user, foreign_key: true, null: false

      t.timestamps null: false
    end

    create_table :events do |t|
      t.string :uid, null: :false, index: { unique: true }
      t.string :name, null: :false
      t.string :fullname
      t.string :description
      t.string :organizer_name
      t.string :primary_sns
      t.string :info_url
      t.string :hashtag
      t.references :platform, { foreign_key: true, null: false}
      t.references :category, { foreign_key: true, null: false}
      t.string :visibility, null: false
      t.string :taste, null: :false
      t.integer :capacity, null: false
      t.string :default_audience_role, null: false
      t.integer :trust, null: :false

      t.references :created_user, foreign_key: { to_table: :users }
      t.references :updated_user, foreign_key: { to_table: :users }
      t.timestamps null: false
    end

    create_table :event_flavors do |t|
      t.references :event, foreign_key: true, null: :false
      t.references :flavor, foreign_key: true, null: :false

      t.timestamps null: false
    end

    create_table :event_schedules do |t|
      t.string :uid, null: :false, index: { unique: true }
      t.references :event, foreign_key: true, null: false
      t.datetime :assemble_at
      t.datetime :open_at
      t.datetime :start_at, null: false
      t.datetime :end_at, null: false
      t.datetime :close_at
      t.string :repeat
      t.string :resolution
      t.datetime :repeat_until

      t.references :created_user, foreign_key: { to_table: :users }
      t.references :updated_user, foreign_key: { to_table: :users }
      t.timestamps null: false
    end

    create_table :event_histories do |t|
      t.string :uid, null: :false, index: { unique: true }
      t.references :event, foreign_key: true, null: false
      t.string :resolution, null: false
      t.integer :capacity, null: false
      t.string :default_audience_role, null: false
      t.datetime :assembled_at
      t.datetime :opened_at
      t.datetime :started_at, null: false
      t.datetime :ended_at, null: false
      t.datetime :closed_at

      t.references :created_user, foreign_key: { to_table: :users }
      t.references :updated_user, foreign_key: { to_table: :users }
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
      t.string :uid, null: :false, index: { unique: true }
      t.references :user, foreign_key: true, null: false
      t.references :event, foreign_key: true, null: false
      t.datetime :started_at, null: false
      t.string :role, null: :false
      t.string :hashtag

      t.timestamps null: false
    end

    create_table :event_memories do |t|
      t.string :uid, null: :false, index: { unique: true }
      t.references :user, foreign_key: true, null: false
      t.references :event, foreign_key: true, null: false
      t.datetime :started_at, null: false
      t.datetime :published_at, null: false, index: true
      t.string :hashtag
      t.text :body, null: false
      t.json :urls, null: false

      t.timestamps null: false
    end

    create_table :feedbacks do |t|
      t.references :user
      t.string :user_uid
      t.text :title, null: false
      t.text :body, null: false
      t.datetime :resolved_at

      t.timestamps null: false
    end

    create_table :agreements do |t|
      t.string :slug, null: false
      t.text :title, null: false
      t.text :body, null: false
      t.text :published_at, null: false
      t.text :effective_at, null: false

      t.timestamps null: false
    end

    add_index :event_flavors, [:event_id, :flavor_id], unique: true
    add_index :event_histories, [:event_id, :started_at], unique: true
    add_index :hashtag_follows, [:user_id, :hashtag, :role], unique: true
    add_index :event_follows, [:user_id, :event_id], unique: true
    add_index :event_attendances, [:user_id, :event_id, :started_at], unique: true
    add_index :event_memories, [:user_id, :published_at]
  end
end
