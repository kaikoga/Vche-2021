class My::SettingsController < ApplicationController::Bootstrap
  include MyResources

  def show
    authorize!
  end
end
