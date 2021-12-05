class Operations::Daily::Report
  include Operations::Operation

  def initialize
  end

  def validate
    nil
  end

  def perform
    yesterday = 1.days.ago.beginning_of_day..1.days.ago.end_of_day
    message = []
    message << "Environment: #{Vche.env}"
    message << "User: #{User.count} (+#{User.where(created_at: yesterday).count})"
    message << "Event: #{Event.count} (+#{Event.where(created_at: yesterday).count})"
    message << "EventFollow: #{EventFollow.count} (+#{EventFollow.where(created_at: yesterday).count})"
    message << "EventAttendance: #{EventAttendance.count} (+#{EventAttendance.where(created_at: yesterday).count})"
    message << "Feedback: #{Feedback.count} (+#{Feedback.where(created_at: yesterday).count})"

    body = message.join("\n")
    puts body
    webhook = Rails.application.config.x.vche.slack_daily_report_webhook.presence
    Slack::Notifier.new(webhook).ping(body) if webhook
  end
end
