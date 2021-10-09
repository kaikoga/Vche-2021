class SessionsController < ApplicationController
  skip_before_action :require_login, only: [:new, :create]

  def new
    authorize!
  end

  def create
    @user = login(params[:email], params[:password])
    authorize!

    if @user
      redirect_back_or_to(:home, notice: 'Login successful')
    else
      flash.now[:alert] = 'Login failed'
      render action: 'new'
    end
  end

  def destroy
    authorize!
    logout
    redirect_back_or_to(:root, notice: 'Logged out!')
  end

  def purge
    authorize!
    invalidate_active_sessions!
    logout
    redirect_back_or_to(:root, notice: 'Logged out all sessions!')
  end
end
