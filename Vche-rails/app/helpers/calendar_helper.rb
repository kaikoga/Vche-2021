module CalendarHelper
  def css_class_of_time(date, c)
    if date < Time.current.beginning_of_day
      "#{c} -ended"
    elsif date < Time.current.end_of_day
      "#{c} -today"
    else
      c
    end
  end
end
