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
    default_message_for(event_history, without_time: without_time)
  end

  private

  def default_message_for(event_history, without_time: false)
    event = event_history.event
    now = Time.current
    if !event_history.opened?(now)
      message_prefix = 'チェック! '
    elsif !event_history.ended?(now)
      message_prefix = 'チェックイン! '
      without_time = true
    else
      message_prefix = '終了! '
    end
    event_time = without_time ? nil : " #{l(event_history.started_at, format: :mdahm)}"
    "#{message_prefix}#{event.name}#{event_time}\n#{event_url(event)}"
  end
end
