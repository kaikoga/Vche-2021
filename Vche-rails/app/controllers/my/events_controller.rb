class My::EventsController < ApplicationController::Bootstrap
  include MyResources

  def index
    authorize!
    @form = UserEventsForm.new(@user, index_params, paginate: true)
    @events = @form.events
  end

  private

  def index_params
    params.permit(:filter, :page)
  end
end
