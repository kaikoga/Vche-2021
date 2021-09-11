module UserHelper
  def user_icon_tag(user, size: '48px')
    image_tag('/user_128x128.png', height: size, width: size, alt: user.display_name, title: user.display_name)
  end
end
