class Operations::Event::UpdateUserFollow < Operations::Operation
  class UserIsBackstage < StandardError; end

  def initialize(event:, user:, role:)
    @event = event
    @user = user
    @role = role&.to_sym
  end

  def validate
    raise ArgumentError if EventFollow.backstage_role?(role)
    raise UserIsBackstage if EventFollow.backstage_role?(current_role)
  end

  def perform
    if role
      event_follow = user.event_follows.create_or_find_by!(event: event)
      event_follow.update!(role: role)
    else
      user.event_follows.find_by!(event: event).destroy!
    end
  end

  private

  attr_reader :event, :user, :role

  def current_role
    user.event_follows.find_by(event: event)&.role&.to_sym || :irrelevant
  end
end
