class Operations::EventHistory::UpdateUserRole < Operations::Operation
  class UserIsOwner < StandardError; end

  def initialize(event_history:, user:, role:)
    @event_history = event_history
    @user = user
    @role = role.to_sym
  end

  def validate
    true
  end

  def perform
    if role == :irrelevant
      user.event_attendances.for_event_history(event_history).destroy_all
    else
      event_attendance = user.event_attendances.for_event_history(event_history).create_or_find_by!({})
      event_attendance.update!(role: role)
    end
  end

  private

  attr_reader :event_history, :user, :role

  def current_role
    user.event_attendances.for_event_history(event_history)&.role || :irrelevant
  end
end
