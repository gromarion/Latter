Latter::Application.configure do
  # Settings specified here will take precedence over those in config/application.rb

  # In the development environment your application's code is reloaded on
  # every request. This slows down response time but is perfect for development
  # since you don't have to restart the web server when you make code changes
  config.cache_classes = false

  config.eager_load = false

  config.cache_store = :dalli_store
  config.action_controller.perform_caching = true

  # Show full error reports and disable caching
  config.consider_all_requests_local       = true
  config.action_controller.perform_caching = false

  # Don't care if the mailer can't send
  config.action_mailer.raise_delivery_errors = false

  # Print deprecation notices to the Rails logger
  config.active_support.deprecation = :log

  # Only use best-standards-support built into browsers
  config.action_dispatch.best_standards_support = :builtin

  # Do not compress assets
  config.assets.compress = false

  # Expands the lines which load the assets
  config.assets.debug = true

  config.action_mailer.default_url_options = { host: 'localhost:3000' }
  config.action_mailer.asset_host = 'http://localhost:3000'

  config.after_initialize do
    hipchat_config = AppConfiguration.for(:hipchat)
    ::HIPCHAT_CLIENT = HipChat::Client.new(hipchat_config.token, api_version: 'v2')
    ::PING_PONG_ROOM_NAME = hipchat_config.ping_pong_room_name

    pingpously_config = AppConfiguration.for(:pingpously_config)
    ::NEMESIS_REQUIRED_WON_GAMES = pingpously_config.nemesis_required_won_games.to_i
    ::LEVEL_1_MAX_POINTS = pingpously_config.level_1_max_points.to_i
    ::LEVEL_2_MAX_POINTS = pingpously_config.level_2_max_points.to_i
    ::LEVEL_3_MAX_POINTS = pingpously_config.level_3_max_points.to_i
    ::LEVEL_4_MAX_POINTS = pingpously_config.level_4_max_points.to_i
  end
end
