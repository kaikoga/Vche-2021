module TwitterHelper
  def intent_url_for_event(event)
    event_history = event.next_history
    intent_url_for(event_history, without_time: true)
  end

  def intent_url_for(event_history, without_time: false)
    event = event_history.event
    appeal = event_history.event_appeal_for(current_user)
    intent_url(
      message: appeal_message_for(event_history, appeal, without_time: without_time),
      hashtags: [appeal.use_hashtag? ? event.hashtag_without_hash : nil, 'Vche'].compact,
      related: [event.primary_sns_name, 'vche_jp'].compact
    )
  end

  private

  def intent_url(message:, hashtags: [], related: [])
    uri = Addressable::URI.parse('https://twitter.com/intent/tweet')
    uri.query_values = {
      text: message,
      hashtags: hashtags.join(','),
      related: related.join(',')
    }.compact
    uri.to_s
  end

  def appeal_message_for(event_history, appeal, without_time: false, without_url: false)
    event = event_history.event
    unless event.visible? || !appeal.use_system_footer?
      without_time = true
      without_url = true
    end

    now = Time.current
    if !event_history.opened?(now)
      message = appeal.choose_message(:before)
    elsif !event_history.ended?(now)
      message = appeal.choose_message
      without_time = true
    else
      message = appeal.choose_message(:after)
    end

    message += " #{l(event_history.started_at, format: :mdahm)}" unless without_time
    message += "\n#{event_url(event)}" unless without_url
    message
  end
end
