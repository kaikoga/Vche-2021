class Operations::User::Destroy
  include Operations::Operation

  class UserIsOwner < StandardError; end

  def initialize(user:)
    @user = user
  end

  def validate
    raise UserIsOwner if user.owned_events.exists?
  end

  def perform
    user.destroy!
  end

  private

  attr_reader :user
end
