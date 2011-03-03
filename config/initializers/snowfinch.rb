require Rails.root.join("lib/configuration.rb")
require Rails.root.join("lib/mongo_ext.rb")

Snowfinch::Application.configure do
  config.action_mailer.default_url_options = {
    :host => Snowfinch.configuration[:host]
  }
end

Snowfinch::Collector.db = Mongo.db
