class My::UsersController < ApplicationController::Bootstrap
  include MyResources

  def delete
    authorize!
    Operations::User::Destroy.new(user: current_user, confirm: params[:confirm]).perform!
    redirect_to :root, notice: I18n.t('notice.my/users.delete.success')
  rescue Operations::User::Destroy::Confirm
    redirect_to my_settings_path, notice: I18n.t('notice.my/users.delete.confirm')
  rescue Operations::User::Destroy::UserIsOwner
    redirect_to my_settings_path
  end
end
