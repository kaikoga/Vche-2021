class SorceryInvalidateActiveSessions < ActiveRecord::Migration[6.1]
  def self.up
    add_column :users, :invalidate_sessions_before, :datetime, default: nil
  end

  def self.down
    remove_column :users, :invalidate_sessions_before
  end
end
