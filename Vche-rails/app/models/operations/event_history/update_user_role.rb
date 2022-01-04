class Operations::EventHistory::UpdateUserRole
  include Operations::Operation

  class Outsider < StandardError; end

  def initialize(event_history:, user:, role:)
    @event_history = event_history
    @user = user
    @role = role&.to_sym
  end

  def validate
    raise ArgumentError if role == :irrelevant
    raise Outsider unless EventAttendance.backstage_role?(role) || EventAttendance.backstage_role?(current_role)
  end

  def perform
    if role
      event_attendance = user.event_attendances.for_event_history(event_history).create_or_find_by!({})
      event_attendance.update!(role: role)
      @user.become_staff! if EventAttendance.backstage_role?(role)
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
