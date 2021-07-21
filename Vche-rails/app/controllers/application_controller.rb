class ApplicationController < ActionController::Base
  include Banken

  layout 'application_bootstrap'

  before_action :require_login

  rescue_from Banken::NotAuthorizedError, with: :not_authorized

  private

  def not_authenticated
    redirect_to login_path, alert: "Please login first"
  end

  def not_authorized
    redirect_to root_path, alert: "Not allowed"
  end
end
