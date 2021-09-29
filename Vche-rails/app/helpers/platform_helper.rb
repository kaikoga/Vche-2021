module PlatformHelper
  def inline_platform_tag(platform)
    tag.span class: 'inline -platform' do
      platform.name
    end
  end
end
