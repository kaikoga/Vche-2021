module UserHelper
  def user_icon_tag(user, size: :medium)
    class_name = size ? "user__icon -#{size}" : 'user__icon'
    size_num = icon_size_num(size)

    image_tag('/user_128x128.png', class: class_name, width: size_num, height: size_num, alt: user.display_name, title: user.display_name)
  end

  def user_twitter_id(user)
    user.primary_sns.split('/')[-1]
  end

  def user_twitter_url(user)
    "https://twitter.com/#{user_twitter_id(user)}"
  end
end
