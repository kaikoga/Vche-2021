class Operations::Event::Destroy
  include Operations::Operation

  class UserIsOwner < StandardError; end

  def initialize(event:, user:)
    @event = event
    @user = user
  end

  def validate
  end

  def perform
    @event.updated_user = user
    @event.visibility = :deleted
    @event.save!(context: :destroy)
    @event.event_follow_requests.undetermined.update_all(state: 'event_destroyed')
  end

  private

  attr_reader :event, :user
end
