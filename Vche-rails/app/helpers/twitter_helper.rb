module TwitterHelper
  def intent_url_for_event(event)
    event_history = event.next_history
    intent_url_for(event_history, without_time: true)
  end

  def intent_url_for(event_history, without_time: false)
    event = event_history.event
    intent_url(
      message: message_for(event_history, without_time: without_time),
      hashtags: [event.hashtag_without_hash, 'Vche'].compact,
      related: [event.primary_sns_name, 'vche_jp'].compact
    )
  end

  def intent_url(message:, hashtags: [], related: [])
    uri = Addressable::URI.parse('https://twitter.com/intent/tweet')
    uri.query_values = {
      text: message,
      hashtags: hashtags.join(','),
      related: related.join(',')
    }.compact
    uri.to_s
  end

  def message_for(event_history, without_time: false)
    event = event_history.event
    appeal = event_history.event_appeal_for(current_user)
    now = Time.current
    if !event_history.opened?(now)
      message = appeal&.choose_message(:before) || "チェック! #{event.name}"
    elsif !event_history.ended?(now)
      message = appeal&.message || "チェックイン! #{event.name}"
      without_time = true
    else
      message = appeal&.choose_message(:after) || "終了! #{event.name}"
    end
    unless without_time
      message += " #{l(event_history.started_at, format: :mdahm)}"
    end
    "#{message}\n#{event_url(event)}"
  end
end
