module EventHistoryHelper
  def capacity_and_attendance_text(event_history)
    if event_history.capacity > 0
      "#{event_history.event_audiences.count} / #{event_history.capacity} (#{event_history.event_backstage_members.count})"
    else
      "#{event_history.event_audiences.count} (#{event_history.event_backstage_members.count})"
    end
  end
end
