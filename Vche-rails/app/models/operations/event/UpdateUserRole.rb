class Operations::Event::UpdateUserRole < Operations::Operation
  class UserIsOwner < StandardError; end

  def initialize(event:, user:, role:)
    @event = event
    @user = user
    @role = role.to_sym
  end

  def validate
    raise ArgumentError if role == :owner
    raise UserIsOwner if current_role == :owner
  end

  def perform
    if role == :irrelevant
      user.event_follows.find_by!(event: event).destroy!
    else
      event_follow = user.event_follows.create_or_find_by!(event: event)
      event_follow.update!(role: role)
    end
  end

  private

  attr_reader :event, :user, :role

  def current_role
    user.event_follows.find_by(event: event)&.role || :irrelevant
  end
end
