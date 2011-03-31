require File.expand_path("../boot", __FILE__)

require "rails/all"
require "benchmark"

Bundler.require(:default, Rails.env) if defined?(Bundler)

module Snowfinch
  class Application < Rails::Application

    require Rails.root.join("lib/configuration.rb")

    # Set Time.zone default to the specified zone and make Active Record
    # auto-convert to this zone.  Run "rake -D time" for a list of tasks for
    # finding time zone names. Default is UTC.
    config.time_zone = "Helsinki"

    # Default JavaScript files.
    config.action_view.javascript_expansions[:defaults] =
      %w(jquery jquery.flot rails)

    # Configure the default encoding used in templates for Ruby 1.9.
    config.encoding = "utf-8"

    # Configure sensitive parameters which will be filtered from the log file.
    config.filter_parameters += [:password]

    # We do acceptance testing.
    config.app_generators.controller_specs false
    config.app_generators.request_specs false
    config.app_generators.routing_specs false
    config.app_generators.view_specs false

    # Host to link to in mailers. Look at config/snowfinch.yml for the values.
    config.action_mailer.default_url_options = {
      :host => Snowfinch.configuration[:host]
    }
  end
end
