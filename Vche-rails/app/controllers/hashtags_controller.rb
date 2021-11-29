class HashtagsController < ApplicationController::Bootstrap
  skip_before_action :require_login, only: [:index, :show]

  def index
    @hashtags = Event.public_or_over.accessible_or_over.group(:hashtag).select('hashtag, count(1) AS cnt').page(params[:page]).per(50)
    authorize!
  end

  def show
    authorize!
    scoped_events = Event.public_or_over.where(hashtag: params[:id]).order(trust: :desc)
    @form = CalendarPresenterForm.new(scoped_events, show_params, filter: { trust: 'all' }, paginate: true)

    @calendar = @form.presenter(current_user: current_user, candidate: true)
    @events = @form.events
  end

  def show_params
    params.permit(:id, :calendar, :date, :category, :trust, :taste)
  end
end
