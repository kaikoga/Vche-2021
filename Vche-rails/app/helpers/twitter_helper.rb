module TwitterHelper
  def intent_url(message:, hashtags: [], related: [])
    message_ = CGI.escape message
    hashtags_ = CGI.escape hashtags.join(',')
    related_ = CGI.escape related.join(',')
    "https://twitter.com/intent/tweet?text=#{message_}&hashtags=#{hashtags_}&related=#{related_}"
  end
end
