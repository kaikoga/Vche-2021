class Operations::EventHistory::UpdateUserAttendance < Operations::Operation
  class UserIsAudience < StandardError; end

  def initialize(event_history:, user:, role:)
    @event_history = event_history
    @user = user
    @role = role&.to_sym
  end

  def validate
    raise ArgumentError if role == :irrelevant
    raise UserIsAudience if user.following_event_as_audience?(event_history.event) && EventAttendance.backstage_role?(role)
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
    user.event_attendances.for_event_history(event_history).first&.role&.to_sym || :irrelevant
  end
end
