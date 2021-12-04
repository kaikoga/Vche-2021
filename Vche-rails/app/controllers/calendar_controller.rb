class CalendarController < ApplicationController::Bootstrap
  skip_before_action :require_login

  def index
    authorize!

    @form = CalendarPresenterForm.new(Event.public_or_over, index_params, filter: { trust: Rails.application.config.x.vche.public_calendar_trust })
    @calendar = @form.presenter(current_user: current_user, display_user: current_user, candidate: params[:taste] == 'all', offline: false)
  end

  private

  def index_params
    @index_params ||= params.permit(:calendar, :date, :category, :trust, :taste)
  end
end
