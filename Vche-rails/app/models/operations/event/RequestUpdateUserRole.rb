class Operations::Event::RequestUpdateUserRole < Operations::Operation
  class UserIsOwner < StandardError; end

  def initialize(event:, user:, approver:, role:)
    @event = event
    @user = user
    @approver = approver
    @role = role&.to_sym
  end

  def validate
    raise ArgumentError if role == :irrelevant
    raise ArgumentError if role == :owner
    raise UserIsOwner if current_role == :owner
  end

  def perform
    if role
      event_follow_requests.find_or_create_by!({}).update!(approver: approver, role: role, message: '')
    else
      event_follow_requests.destroy_all
    end
  end

  private

  attr_reader :event, :user, :approver, :role

  def event_follow_requests
    user.event_follow_requests.where(event: event, started_at: nil)
  end

  def current_role
    user.event_follows.find_by(event: event)&.role&.to_sym || :irrelevant
  end
end
