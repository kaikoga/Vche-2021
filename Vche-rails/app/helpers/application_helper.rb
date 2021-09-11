module ApplicationHelper
  def icon_size_num(size)
    case size
    when :large then '64px'
    else '48px'
    end
  end
end
