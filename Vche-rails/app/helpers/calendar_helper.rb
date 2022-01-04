module CalendarHelper
  def css_class_of_time(date, class_name)
    if date < Time.current.beginning_of_day
      "#{class_name} -ended"
    elsif date < Time.current.end_of_day
      "#{class_name} -today"
    else
      class_name
    end
  end
end
