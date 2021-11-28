class CalendarController < ApplicationController::Bootstrap
  skip_before_action :require_login

  def index
    authorize!

    form = CalendarPresenterForm.new(Event.public_or_over, index_params, filter: true)
    @calendar = form.presenter(current_user: current_user, candidate: params[:taste] == 'all')
  end

  private

  def index_params
    @index_params ||= params.permit(:calendar, :date, :category, :trust, :taste)
  end
end
