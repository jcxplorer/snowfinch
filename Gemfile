source :rubygems

gem "rails", "3.0.6"

gem "devise"
gem "haml"
gem "kisko-compass", :git => "git@github.com:kiskolabs/kisko-compass.git"
gem "simple_form"
gem "mongo"
gem "bson_ext"
gem "snowfinch-collector",
    :git => "git@github.com:jcxplorer/snowfinch-collector.git",
    :require => "snowfinch/collector"

group :test do
  gem "autotest", :require => false
  gem "autotest-growl", :require => false
  gem "capybara"
  gem "database_cleaner"
  gem "email_spec"
  gem "factory_girl_rails", ">= 1.1.beta1"
  gem "fuubar"
  gem "launchy"
  gem "shoulda-matchers", :require => false
  gem "simplecov", :require => false
  gem "timecop"
end

group :production do
  gem "pg"
end

group :development, :test do
  gem "rspec-rails"
  gem "sqlite3-ruby"
  gem "steak"
end
