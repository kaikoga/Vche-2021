module ApplicationHelper
  def icon_size_num(size)
    case size
    when :large then '64px'
    else '48px'
    end
  end

  def time_span_text(start_at, end_at)
    case (end_at.beginning_of_day - start_at.beginning_of_day) / 1.day
    when 0
      [l(start_at), l(end_at, format: :hm)]
    when 1
      [l(start_at), l(end_at.change(hour:0), format: :hm).sub("0", "#{end_at.hour + 24}")]
    else
      [l(start_at), l(end_at)]
    end
  end
end
