module MetaHelper
  def set_meta_for(*objects) # rubocop:disable Naming/AccessorMethodName
    set_meta_title_for(*objects)
    last_object = objects.rindex { |object| object.is_a?(ActiveRecord::Base) }
    set_meta_card_for(*objects[last_object..])
  end

  def set_meta_title_for(*objects) # rubocop:disable Naming/AccessorMethodName
    page_title = name_for_meta(objects)
    layout_head_title("#{t('vche.meta.vche')} | #{page_title}")
  end

  def set_meta_card_for(*objects) # rubocop:disable Naming/AccessorMethodName
    title = name_for_meta(objects)
    meta_title("#{title.truncate(63)} | #{t('vche.meta.vche')}")

    object = objects.first
    singular = objects.count == 1
    case object
    when String
      meta_description(default_meta_description)
    when User
      meta_description(singular ? object.bio : default_meta_description)
      meta_twitter_creator(twitter_creator_for_user(object))
    when Account
      meta_description("#{t('vche.meta.user')}: #{object.user.display_name}")
      meta_twitter_creator(twitter_creator_for_user(object.user))
    when Event
      meta_description("#{object.hashtag} #{object.description}")
      meta_twitter_creator(twitter_creator_for_user(object))
    when EventHistory
      meta_description("#{object.event.hashtag} #{object.event.description}")
      meta_twitter_creator(twitter_creator_for_user(object.event))
    when EventMemory
      meta_description("#{t('vche.meta.user')}: #{object.user.display_name}")
      meta_twitter_creator(twitter_creator_for_user(object.user))
    else
      nil
    end
  end

  private

  def name_for_meta(object, long: false)
    case object
    when Array
      object.map { |o| name_for_meta(o, long: object.count == 1) }.join(' | ')
    when String
      object
    when User
      object.display_name
    when Account
      "#{object.platform.name}: #{object.display_name}"
    when Event
      object.name
    when EventHistory
      if long
        "#{object.resolution_text}: #{object.event.name} #{l(object.started_at)}"
      else
        object.event.name
      end
    when EventMemory
      "#{t('vche.meta.event_memory')}: #{object.event.name}"
    when OfflineSchedule
      object.name
    else
      ''
    end
  end

  def twitter_creator_for_user(user_or_event)
    user_or_event.primary_sns == 'twitter' && "@#{user_or_event.primary_sns_name}"
  end

  def default_meta_description
    t('vche.meta.default_meta_description')
  end

  def layout_head_title(value)
    content_for(:layout_head_title, flush: true) { value }
  end

  def meta_title(value)
    content_for(:meta_title, flush: true) { value }
  end

  def meta_description(value)
    content_for(:meta_description, flush: true) { value.to_s.truncate(96) }
  end

  def meta_twitter_creator(value)
    content_for(:meta_twitter_creator, flush: true) { value } if value
  end
end
