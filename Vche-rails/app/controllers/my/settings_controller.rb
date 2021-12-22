class My::SettingsController < ApplicationController::Bootstrap
  def show
    authorize!
    @user = current_user
  end
end
