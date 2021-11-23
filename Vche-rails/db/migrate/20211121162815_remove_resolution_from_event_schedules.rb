class RemoveResolutionFromEventSchedules < ActiveRecord::Migration[6.1]
  def change
    remove_column :event_schedules, :resolution, :string, after: :repeat
  end
end
