require "spork"

Spork.prefork do
  require "rails/application"
  Spork.trap_method(Rails::Application, :reload_routes!)

  ENV["RAILS_ENV"] ||= "test"
  require File.expand_path("../../config/environment", __FILE__)
  require "rspec/rails"
  require "shoulda-matchers"
  require "email_spec"

  Dir[Rails.root.join("spec/support/**/*.rb")].each {|f| require f}

  RSpec.configure do |config|
    config.mock_with :rspec
    config.use_transactional_fixtures = true

    config.include EmailSpec::Helpers
    config.include EmailSpec::Matchers

    config.before(:each) do
      Capybara.reset_sessions!

      Mongo.db.collections.each do |collection|
        collection.drop unless collection.name =~ /^system\./
      end
    end

    config.after(:each) do
      Timecop.return
    end
  end
end

Spork.each_run do
  FactoryGirl.registry = FactoryGirl::Registry.new
  load "factories.rb"

  I18n.reload!
end

