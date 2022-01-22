class UserEventsForm
  attr_reader :user, :params, :filter_name, :paginate, :exclude

  def initialize(user, filtered_params, paginate: false, exclude: nil)
    @user = user
    @params = filtered_params
    @filter_name = params[:filter]
    @paginate = paginate
    @exclude = Array(exclude)
  end

  def excluded?(filter)
    filter.in?(exclude)
  end

  def events
    @events ||=
      begin
        events = events_for(filter)
        events = events.page(params[:page]) if paginate
        events
      end
  end

  def events_for(filter)
    user.send(events_field_for(filter))
  end

  def events_field
    events_field_for(filter)
  end

  private

  def filter
    filter_for(filter_name)
  end

  def filter_for(filter_name)
    filter =
      case filter_name.to_s
      when 'created'
        :created
      when 'backstage'
        :backstage
      when 'audience'
        :audience
      else
        :following
      end
    excluded?(filter) ? :following : filter
  end

  def events_field_for(filter)
    :"#{filter}_events"
  end
end
