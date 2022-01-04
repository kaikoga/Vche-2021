class ApplicationController < ActionController::Base
  include Banken

  before_action :require_login
  after_action :verify_authorized unless Rails.env.production?

  if Rails.application.config.x.vche.pretty_not_found
    rescue_from Banken::NotAuthorizedError, with: :not_found
    rescue_from ActiveRecord::RecordNotFound, with: :not_found
  end

  private

  def not_authenticated
    render 'error_not_authenticated'
  end

  def not_found
    render 'error_not_found'
  end

  class Bootstrap < ApplicationController
    layout 'application_bootstrap'

    before_action :require_existing_user
    before_action :require_agreement

    private

    def require_existing_user
      return unless current_user

      if current_user.visibility.deleted?
        redirect_to new_recovery_path
      end
    end

    def require_agreement
      return unless current_user

      unless current_user.agreed?(Agreement.modified_at)
        redirect_to confirm_agreements_path
      end
    end
  end
end
