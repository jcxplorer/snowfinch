# This file is used by Rack-based servers to start the application.

require ::File.expand_path('../config/environment',  __FILE__)

map "/" do
  run Snowfinch::Application
end

map "/collector" do
  run Snowfinch::Collector
end
