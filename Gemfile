source :rubygems

gem "rails", "3.0.4"

gem "devise"
gem "haml"
gem "kisko-compass", :git => "git@github.com:kiskolabs/kisko-compass.git"
gem "rdiscount"
gem "RedCloth"
gem "simple_form"

group :development do
  gem "awesome_print", :require => "ap"
end

group :test do
  gem "autotest"
  gem "autotest-growl", :require => false
  gem "capybara"
  gem "factory_girl_rails", ">= 1.1.beta1"
  gem "launchy"
  gem "spork", "~> 0.9.0.rc"
end

group :production do
  gem "mysql2"
end

group :development, :test do
  gem "rspec-rails"
  gem "sqlite3-ruby", :require => "sqlite3"
  gem "steak"
end
