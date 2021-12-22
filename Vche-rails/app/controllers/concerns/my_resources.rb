module MyResources
  extend ActiveSupport::Concern

  included do
    before_action :find_current_user

    private

    def find_current_user
      @user = current_user
    end
  end
end
