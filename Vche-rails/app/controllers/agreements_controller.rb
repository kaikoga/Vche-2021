class AgreementsController < ApplicationController::Bootstrap
  skip_before_action :require_login
  skip_before_action :require_agreement

  skip_after_action :verify_authorized, raise: false

  def tos
    @agreement = Agreement.by_slug(:tos)
    render 'agreements/show'
  end

  def privacy_policy
    @agreement = Agreement.by_slug(:privacy_policy)
    render 'agreements/show'
  end

  def confirm
    @agreement_tos = Agreement.by_slug(:tos)
    @agreement_privacy_policy = Agreement.by_slug(:privacy_policy)

    @agreements = []
    @agreements << @agreement_tos unless current_user.agreed?(@agreement_tos.published_at)
    @agreements << @agreement_privacy_policy unless current_user.agreed?(@agreement_privacy_policy.published_at)
    render 'agreements/confirm'
  end

  def agree
    current_user.update!(agreed_at: Time.current)
    redirect_to home_path
  end
end
