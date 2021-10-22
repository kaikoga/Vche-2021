class OauthsController < ApplicationController
  skip_before_action :require_login, raise: false
  skip_after_action :verify_authorized, raise: false

  USER_INFO_MAPPING_LOGIN = { primary_sns: 'screen_name' }.freeze

  # sends the user on a trip to the provider,
  # and after authorizing there back to the callback url.
  def oauth
    login_at(auth_params[:provider])
  end

  def callback
    provider = callback_params[:provider]
    redirect_to login_url and return if callback_params[:denied].present?

    if @user = login_from(provider)
      # Keep user data to date
      @user.update!(user_attrs(USER_INFO_MAPPING_LOGIN, @user_hash))

      redirect_to root_path, :notice => "Logged in from #{provider.titleize}!"
    else
      begin
        # @user = create_from(provider)
        @user = create_from(provider) do |user|
          user.visibility = :public
          user.password = user.password_confirmation = SecureRandom.hex
          user.valid?
        end

        unless @user
          redirect_to root_path, :alert => "Failed to login from #{provider.titleize}!"
        end

        # NOTE: this is the place to add '@user.activate!' if you are using user_activation submodule

        reset_session # protect from session fixation attack
        auto_login(@user)
        redirect_to root_path, :notice => "Logged in from #{provider.titleize}!"
        # rescue
        #  redirect_to root_path, :alert => "Failed to login from #{provider.titleize}!"
      end
    end
  end

  private

  def auth_params
    params.permit(:provider)
  end

  def callback_params
    params.permit(:provider, :oauth_token, :oauth_verifier, :denied)
  end
end
