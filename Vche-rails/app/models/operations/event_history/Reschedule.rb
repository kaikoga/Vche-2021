class Operations::EventHistory::Reschedule < Operations::Operation
  class Unchanged < StandardError; end

  def initialize(event_history:, params:, user:)
    @event_history = event_history
    @params = params
    @user = user
  end

  def validate
    raise ArgumentError if event_history.resolution.phantom?
    raise Unchanged if event_history.started_at == started_at
  end

  def perform
    @new_event_history = event_history.event.find_or_build_history(started_at)
    new_event_history.assign_attributes(event_history.attributes.except('id', 'uid'))
    new_event_history.assign_attributes(params)
    new_event_history.created_user = user
    new_event_history.updated_user = user
    new_event_history.save!
    event_history.update!(resolution: :moved)
    new_event_history
  end

  private

  attr_reader :event_history, :new_event_history, :params, :user

  def started_at
    @started_at ||= Time.zone.parse(params[:started_at])
  end
end
