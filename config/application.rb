require File.expand_path('../boot', __FILE__)

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Dalphi
  class Application < Rails::Application
    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.
    config.active_job.queue_adapter = :delayed_job

    config.cache_store = :redis_store,
                         "redis://#{ENV.fetch('REDIS_HOST', 'localhost')}:6379/0/cache",
                         { expires_in: 90.minutes }

    # Add the custom config
    config.x.dalphi = config_for(:dalphi)
  end
end
