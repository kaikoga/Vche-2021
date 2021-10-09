class AgreementsController < ApplicationController::Bootstrap
  skip_before_action :require_login
  skip_after_action :verify_authorized

  def tos
    @agreement = Agreement.by_slug(:tos)
    render 'agreements/show'
  end

  def privacy_policy
    @agreement = Agreement.by_slug(:privacy_policy)
    render 'agreements/show'
  end
end
