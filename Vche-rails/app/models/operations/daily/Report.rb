class Operations::Daily::Report < Operations::Operation
  def initialize
  end

  def validate
    nil
  end

  def perform
    yesterday = 1.days.ago.beginning_of_day..1.days.ago.end_of_day
    message = []
    message << "User: #{User.count} (+#{User.where(created_at: yesterday).count})"
    message << "Event: #{Event.count} (+#{Event.where(created_at: yesterday).count})"
    message << "EventFollow: #{EventFollow.count} (+#{EventFollow.where(created_at: yesterday).count})"
    message << "EventAttendance: #{EventAttendance.count} (+#{EventAttendance.where(created_at: yesterday).count})"
    message << "Feedback: #{Feedback.count} (+#{Feedback.where(created_at: yesterday).count})"

    puts message.join("\n")
  end
end
