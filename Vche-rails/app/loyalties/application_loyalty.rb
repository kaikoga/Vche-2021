class ApplicationLoyalty
  include Banken

  attr_reader :user, :record

  def initialize(user, record)
    @user = user
    @record = record
  end

  def index?
    false
  end

  def show?
    false
  end

  def create?
    false
  end

  def new?
    create?
  end

  def update?
    false
  end

  def edit?
    update?
  end

  def destroy?
    false
  end

  concerning :Global do
    # admin is outside control of banken (see /config/initializers/active_admin.rb)
    def admin?
      user&.admin_role == 'admin'
    end
  end
end
