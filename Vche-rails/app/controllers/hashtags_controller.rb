class HashtagsController < ApplicationController
  skip_before_action :require_login, only: [:index, :show]

  def index
    @hashtags = Event.public_or_over.accessible_or_over.group(:hashtag).select('hashtag, count(1) AS cnt').page(params[:page]).per(50)
    authorize!
  end

  def show
    @events = Event.public_or_over.with_category_param(params[:category]).with_taste_param(params[:taste]).where(hashtag: params[:id]).order(trust: :desc).page(params[:page])
    authorize!

    year = show_params[:year]&.to_i
    month = show_params[:month]&.to_i
    @calendar = CalendarPresenter.new(@events, user: current_user, year: year, month: month, months: 1, days: 0)
  end

  def show_params
    params.permit(:year, :month)
  end
end
