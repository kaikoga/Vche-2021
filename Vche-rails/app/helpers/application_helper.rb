module ApplicationHelper
  def icon_size_num(size)
    case size
    when :small then '32px'
    when :medium then '48px'
    when :large then '64px'
    else '48px'
    end
  end

  def time_span_text(start_at, end_at)
    repeat_time_span_text(:oneshot, start_at, end_at)[1..2]
  end

  def repeat_time_span_text(repeat, start_at, end_at)
    case repeat.to_sym
    when :every_day
      repeat_text = EventSchedule.repeat.find_value(repeat).text
      start_at_text = l(start_at, format: :hm)
    when :every_other_week
      repeat_text = EventSchedule.repeat.find_value(repeat).text
      start_at_text = l(start_at)
    when :every_week, :first_week, :second_week, :third_week, :fourth_week, :fifth_week, :even_week, :odd_week, :last_week
      repeat_text = "#{EventSchedule.repeat.find_value(repeat).text} #{l(start_at, format: '%A')}"
      start_at_text = l(start_at, format: :hm)
    else
      repeat_text = ''
      start_at_text = l(start_at)
    end
    case (end_at.beginning_of_day - start_at.beginning_of_day) / 1.day
    when 0
      [repeat_text, start_at_text, l(end_at, format: :hm)]
    when 1
      [repeat_text, start_at_text, l(end_at.change(hour:0), format: :hm).sub("0", "#{end_at.hour + 24}")]
    else
      [repeat_text, start_at_text, l(end_at)]
    end
  end

  # from Kaminari::Helpers::Tag
  PARAM_KEY_EXCEPT_LIST = [:authenticity_token, :commit, :utf8, :_method, :script_name, :original_script_name].freeze
  def filtered_params
    params.to_unsafe_h.with_indifferent_access.except(*PARAM_KEY_EXCEPT_LIST)
  end
end
