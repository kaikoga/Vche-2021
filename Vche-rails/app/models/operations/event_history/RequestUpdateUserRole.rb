class Operations::EventHistory::RequestUpdateUserRole < Operations::Operation
  class Outsider < StandardError; end

  def initialize(event_history:, user:, approver:, role:)
    @event_history = event_history
    @user = user
    @approver = approver
    @role = role&.to_sym
  end

  def validate
    raise ArgumentError if role == :irrelevant
    raise Outsider unless EventAttendance.backstage_role?(role) || EventAttendance.backstage_role?(current_role)
  end

  def perform
    if role
      event_follow_request = user.event_follow_requests.
        create_or_find_by!(event: event_history.event, approver: approver, started_at: event_history.started_at, message: '')
      event_follow_request.update!(role: role)
    else
      user.event_follow_requests.where(event: event_history.event, started_at: event_history.started_at).destroy_all
    end
  end

  private

  attr_reader :event_history, :user, :approver, :role

  def current_role
    user.event_attendances.for_event_history(event_history).first&.role&.to_sym || :irrelevant
  end
end
