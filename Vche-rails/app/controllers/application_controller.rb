class ApplicationController < ActionController::Base
  include Banken

  before_action :require_login
  after_action :verify_authorized unless Rails.env.production?

  rescue_from Banken::NotAuthorizedError, with: :not_authorized

  private

  def not_authenticated
    redirect_to login_path, alert: "Please login first"
  end

  def not_authorized
    redirect_to root_path, alert: "Not allowed"
  end

  class Bootstrap < ApplicationController
    layout 'application_bootstrap'
  end
end
