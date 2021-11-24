class CalendarController < ApplicationController::Bootstrap
  skip_before_action :require_login

  def index
    authorize!

    scoped_events = Event.public_or_over.where('trust > ?', Event::OWNER_TRUST)
    form = CalendarPresenterForm.new(scoped_events, index_params, filter: true)
    @calendar = form.presenter(current_user: current_user, candidate: params[:taste] == 'all')
  end

  private

  def index_params
    @index_params ||= params.permit(:calendar, :date, :category, :taste)
  end
end
