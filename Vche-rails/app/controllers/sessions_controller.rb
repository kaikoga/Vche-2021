class SessionsController < ApplicationController::Bootstrap
  skip_before_action :require_login, only: [:new, :create]
  skip_before_action :require_agreement

  def new
    authorize!
  end

  def create
    @user = login(params[:email], params[:password])
    authorize!

    if @user
      redirect_back_or_to :home, notice: I18n.t('notice.sessions.create.success')
    else
      flash.now[:alert] = I18n.t('notice.sessions.create.failure')
      render action: 'new'
    end
  end

  def destroy
    authorize!
    logout
    redirect_back_or_to :root, notice: I18n.t('notice.sessions.destroy.success')
  end

  def purge
    authorize!
    invalidate_active_sessions!
    logout
    redirect_back_or_to :root, notice: I18n.t('notice.sessions.purge.success')
  end
end
