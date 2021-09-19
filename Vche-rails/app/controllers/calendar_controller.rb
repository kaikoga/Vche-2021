class CalendarController < ApplicationController
  skip_before_action :require_login

  def index
    year = index_params[:year]&.to_i
    month = index_params[:month]&.to_i

    events = Event.public_or_over.with_taste_param(index_params[:taste]).where('trust > ?', Event::OWNER_TRUST)
    @calendar = CalendarPresenter.new(events, user: current_user, year: year, month: month, months: 1, days: 0)
  end

  private

  def index_params
    @index_params ||= params.permit(:year, :month, :taste)
  end
end
