# see https://github.com/MiniProfiler/rack-mini-profiler/blob/master/README.md

unless Rails.env.production?
  Rack::MiniProfiler.config.position = 'bottom-left'
  Rack::MiniProfiler.config.start_hidden = false
  Rack::MiniProfiler.config.toggle_shortcut = 'P'
end
