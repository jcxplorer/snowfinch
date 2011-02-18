require Rails.root.join("lib/configuration.rb")

Snowfinch::Application.configure do
  config.action_mailer.default_url_options = {
    :host => Snowfinch.configuration[:host]
  }
end
