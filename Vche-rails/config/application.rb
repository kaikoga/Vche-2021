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

  puts "VCHE_ENV=#{Vche.env}"

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

    config.x.password_login = Vche.env.local?
  end
end
