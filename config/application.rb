require_relative "boot"

require "rails"
# Pick the frameworks you want:
require "active_model/railtie"
require "active_job/railtie"
require "active_record/railtie"
require "active_storage/engine"
require "action_controller/railtie"
require "action_mailer/railtie"
require "action_mailbox/engine"
require "action_text/engine"
require "action_view/railtie"
require "action_cable/engine"
# require "rails/test_unit/railtie"

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Changepack
  class Application < Rails::Application
    config.paths.add 'platform/lib', eager_load: true
    config.paths.add 'connect/lib', eager_load: true
    config.paths.add 'write/lib', eager_load: true
    config.autoload_paths << Rails.root.join("app/views")
    config.autoload_paths << Rails.root.join("app/views/layouts")
    config.autoload_paths << Rails.root.join("app/views/components")
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 7.0

    # Configuration for the application, engines, and railties goes here.
    #
    # These settings can be overridden in specific environments using the files
    # in config/environments, which are processed later.
    #
    # config.time_zone = "Central Time (US & Canada)"

    # Don't generate system test files.
    config.generators.system_tests = nil
    config.generators.template_engine = :slim
    config.generators.orm :active_record, primary_key_type: :string

    config.active_job.queue_adapter = :sidekiq

    config.active_support.remove_deprecated_time_with_zone_name = true
  end

  def self.redis_ssl_verify_mode
    # Introduced this method to fix the issue in heroku where redis connections fail for Redis 6.
    # Unless the redis verify mode is explicitly specified as none, we will fall back to the default 'verify peer'.
    # Ref: https://www.rubydoc.info/stdlib/openssl/OpenSSL/SSL/SSLContext#DEFAULT_PARAMS-constant
    ENV['REDIS_OPENSSL_VERIFY_MODE'] == 'none' ? OpenSSL::SSL::VERIFY_NONE : OpenSSL::SSL::VERIFY_PEER
  end
end
