module TwitterHelper
  def intent_url_for_event(event)
    event_history = event.find_or_build_history(Time.current)
    message =
      if (event_history.opened_at..event_history.ended_at).cover?(Time.current)
        "Check in! #{event.name}\n#{event_url(event)}"
      else
        "Check! #{event.name}\n#{event_url(event)}"
      end

    intent_url(
      message: message,
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
end
