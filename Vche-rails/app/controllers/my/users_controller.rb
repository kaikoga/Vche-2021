class My::UsersController < ApplicationController::Bootstrap
  include MyResources

  def delete
    authorize!
    Operations::User::Delete.new(user: current_user, confirm: params[:confirm]).perform!
    invalidate_active_sessions!
    logout
    redirect_to :root, notice: I18n.t('notice.my/users.delete.success')
  rescue Operations::User::Delete::Confirm
    redirect_to my_settings_path, notice: I18n.t('notice.my/users.delete.confirm')
  rescue Operations::User::Delete::UserIsOwner
    redirect_to my_settings_path
  end
end
