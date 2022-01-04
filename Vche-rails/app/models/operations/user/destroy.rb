class Operations::User::Destroy
  include Operations::Operation

  class UserIsOwner < StandardError; end
  class Confirm < StandardError; end

  def initialize(user:, confirm:)
    @user = user
    @confirm = confirm
  end

  def validate
    raise UserIsOwner if user.owned_events.exists?
    raise Confirm unless confirm == 'delete'
  end

  def perform
    @user.visibility = :deleted
    @user.save!(context: :destroy)
  end

  private

  attr_reader :user, :confirm
end
