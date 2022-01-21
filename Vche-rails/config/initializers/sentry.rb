Sentry.init do |config|
  # config.dsn = ENV.fetch('SENTRY_DSN', nil)
  config.breadcrumbs_logger = [:active_support_logger, :http_logger]
  config.environment = Vche.env
  config.release = "vche-rails@#{Vche.version}"

  config.traces_sampler = ->(_context) { true }
end
