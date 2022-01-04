class RecoveriesController < ApplicationController::Bootstrap
  include MyResources

  skip_before_action :require_existing_user

  before_action :require_deleted_user

  def new
    authorize!
  end

  def create
    authorize!
    current_user.update!(visibility: :public)
    redirect_to home_path
  end

  private

  def require_deleted_user
    return unless current_user

    unless current_user.visibility.deleted?
      redirect_to home_path
    end
  end
end
