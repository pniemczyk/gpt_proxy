# frozen_string_literal: true

require_relative 'boot'

require 'rails'
# Pick the frameworks you want:
require 'active_model/railtie'
require 'active_job/railtie'
require 'active_record/railtie'
require 'active_storage/engine'
require 'action_controller/railtie'
require 'action_mailer/railtie'
require 'action_mailbox/engine'
require 'action_text/engine'
require 'action_view/railtie'
require 'action_cable/engine'
# require "rails/test_unit/railtie"

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module GptProxy
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 8.0

    # Please, add to the `ignore` list any other `lib` subdirectories that do
    # not contain `.rb` files, or that should not be reloaded or eager loaded.
    # Common ones are `templates`, `generators`, or `middleware`, for example.
    config.autoload_lib(ignore: %w[assets tasks])

    # Configuration for the application, engines, and railties goes here.
    #
    # These settings can be overridden in specific environments using the files
    # in config/environments, which are processed later.
    #
    # config.time_zone = "Central Time (US & Canada)"
    # config.eager_load_paths << Rails.root.join("extras")
    host = ENV.fetch('APP_HOST')
    https_enabled = ActiveModel::Type::Boolean.new.cast(ENV['HTTPS'])
    host_url = "http#{https_enabled ? 's' : ''}://#{host}"
    config.hosts << host
    config.action_mailer.default_url_options = { host: }
    config.action_mailer.asset_host = host_url
    Rails.application.routes.default_url_options[:host] = host_url
    config.force_ssl = https_enabled

    # Enable CORS for all origins if needed
    if ActiveModel::Type::Boolean.new.cast(ENV['ALLOW_ALL_CORS_ORIGIN'])
      config.action_controller.forgery_protection_origin_check = false
      config.middleware.insert_before 0, Rack::Cors do
        allow do
          origins '*'
          resource(
            '*',
            headers: :any,
            methods: [ :get, :patch, :put, :delete, :post, :options, :head ]
            )
        end
      end
    end

    config.generators do |g|
      g.template_engine :slim
      g.test_framework :minitest, spec: true, fixture: false
      g.fixture_replacement :factory_bot, dir: 'test/factories'
      g.integration_tool :minitest
      g.system_tests nil
    end

    config.view_component.instrumentation_enabled = true
    config.view_component.use_deprecated_instrumentation_name = false
  end
end
