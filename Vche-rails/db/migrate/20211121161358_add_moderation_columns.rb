class AddModerationColumns < ActiveRecord::Migration[6.1]
  def change
    add_column :events, :base_trust, :integer, null: false, after: :trust
    add_column :users, :base_trust, :integer, null: false, after: :trust

    change_column_null :events, :trust, false, 0
  end
end
