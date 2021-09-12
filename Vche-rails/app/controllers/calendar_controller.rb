class CalendarController < ApplicationController
  skip_before_action :require_login

  def index
    @calendar = CalendarPresenter.new(Event.general_or_private.where('trust > ?', Event::OWNER_TRUST), user: current_user, days: 140)
  end
end
