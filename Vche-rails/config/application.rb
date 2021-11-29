require_relative "boot"

require "rails/all"

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Vche
  module_function

  def env
    @env ||= ActiveSupport::StringInquirer.new(ENV["VCHE_ENV"].presence || raise('Please set VCHE_ENV'))
  end

  def version
    @version ||= File.read(File.join(__dir__, "../VCHE_VERSION")).strip || 'unknown'
  end

  puts "VCHE_ENV=#{Vche.env} VCHE_VERSION=#{Vche.version}"

  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 6.1

    config.generators.template_engine = :slim

    # Configuration for the application, engines, and railties goes here.
    #
    # These settings can be overridden in specific environments using the files
    # in config/environments, which are processed later.
    #
    # config.time_zone = "Central Time (US & Canada)"
    # config.eager_load_paths << Rails.root.join("extras")

    config.i18n.default_locale = :ja
    config.time_zone = "Tokyo"

    config.x.vche.password_login = Vche.env.local?
    config.x.vche.pretty_not_found = !Vche.env.local?

    config.x.vche.allow_private_backstage = false

    config.x.vche.public_calendar_trust = ENV.fetch('VCHE_PUBLIC_CALENDAR_TRUST') { 'owner' }

    config.x.vche.support_email = ENV.fetch('VCHE_SUPPORT_EMAIL') { 'support@example.com' }
    config.x.vche.support_github = ENV.fetch('VCHE_SUPPORT_GITHUB') { 'https://example.com/github' }
    config.x.vche.support_twitter = ENV.fetch('VCHE_SUPPORT_TWITTER') { 'https://example.com/twitter' }
    config.x.vche.support_discord = ENV.fetch('VCHE_SUPPORT_DISCORD') { 'https://example.com/discord' }
  end
end
