require "autotest/growl"

Autotest.add_discovery { "rails" }
Autotest.add_discovery { "rspec2" }

Autotest.add_hook :initialize do |at|
  at.add_mapping(/^spec\/acceptance\/.*_spec.rb$/) do |filename|
    filename
  end
end
