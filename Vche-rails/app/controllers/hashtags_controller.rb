class HashtagsController < ApplicationController
  skip_before_action :require_login, only: [:index, :show]

  def index
    @hashtags = Event.public_or_over.accessible_or_over.group(:hashtag).select('hashtag, count(1) AS cnt').page(params[:page]).per(50)
  end

  def show
    @events = Event.public_or_over.with_category_param(params[:category]).with_taste_param(params[:taste]).where(hashtag: params[:id]).order(trust: :desc).page(params[:page])
  end
end
