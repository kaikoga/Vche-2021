class Operations::EventHistory::UpdateUserRole < Operations::Operation

  def initialize(event_history:, user:, role:)
    @event_history = event_history
    @user = user
    @role = role&.to_sym
  end

  def validate
    raise ArgumentError if role == :irrelevant
  end

  def perform
    if role
      event_attendance = user.event_attendances.for_event_history(event_history).create_or_find_by!({})
      event_attendance.update!(role: role)
    else
      user.event_attendances.for_event_history(event_history).destroy_all
    end
  end

  private

  attr_reader :event_history, :user, :role

  def current_role
    user.event_attendances.for_event_history(event_history)&.role || :irrelevant
  end
end
