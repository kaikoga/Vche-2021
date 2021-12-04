class Operations::Event::Destroy < Operations::Operation
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
  end

  private

  attr_reader :event, :user
end
