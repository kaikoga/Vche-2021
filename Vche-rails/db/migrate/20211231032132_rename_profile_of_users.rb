class RenameProfileOfUsers < ActiveRecord::Migration[6.1]
  def change
    rename_column :users, :profile, :bio
  end
end
