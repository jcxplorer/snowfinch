## Snowfinch tracking test
#
# [Snowfinch](https://github.com/jcxplorer/snowfinch) is a realtime web
# analytics application written in
# [Ruby on Rails](http://rubyonrails.org/) and using
# [MongoDB](http://www.mongodb.org/).
#
# This test is an example of how to test several components of an
# application.
#
#
### Background
#
# The system contains three components:
#
# * A JavaScript tracker that executes requests containing click
#   information.
# * A collector application that records the click information from the
#   requests executed by the JavaScript tracker.
# * A Rails application where users can manage sites and see the
#   analytics data.
#
# This test goes through logging in, creating a site, simulating
# copy-pasting of the displayed tracking code into a page, loading the
# page, and checking that the application reports one active visit,
# one pageview, and one visitor. This are the same steps a user would
# follow when using Snowfinch.
#
#
### Why?
#
# Components are tested individually, having automated acceptance and
# unit tests, but nothing ensures that the system works as a whole. This
# test helps ensure that everything is wired up correctly to work.
#
#
### Techniques
#
# Snowfinch is implemented using behavior driven development, but with
# acceptance tests written in Ruby instead of plain English. This allows
# for faster test and development cycles, and having user stories in
# plain English would not bring any big benefit to this specific
# application.
#
#
### Tools
# 
# The tools used for testing are:
#
# * [RSpec](https://github.com/rspec/rspec) is a testing suite for
#   behavior driven development, complete with a mocking framework and
#   Rails integration.
# * [Capybara](https://github.com/jnicklas/capybara) is an acceptance
#   test framework for web applications.
# * [Steak](https://github.com/cavalle/steak) adds some aliases on top
#   RSpec, making it more natural to do acceptance testing. It also
#   contains some Rails generators to get tests going and organized.

# Load the tools and entire application stack.
require File.expand_path(File.dirname(__FILE__) + '/acceptance_helper')

# Define the feature we are testing.
feature "Tracking" do

  # Define the scenario for the test.
  #
  # We need Selenium because the tracking code is written in JavaScript.
  # The `:js => true` option will make the entire scenario run with
  # Selenium.
  scenario "Add the tracking code to a site", :js => true do
    # Create a user with an email and a password.
    Factory :user, :email => "joe@snowfinch.net", :password => "123456"

    # Visit the sign in page. Path helpers are located in
    # `spec/acceptance/support/paths.rb`.
    visit sign_in_page

    # Sign in with the previously created user.
    fill_in "Email",    :with => "joe@snowfinch.net"
    fill_in "Password", :with => "123456"
    click_button "Sign in"

    # Go to the site creation page and create a site.
    click_link "Add a site"
    fill_in "Site name", :with => "Tracking test"
    select "Helsinki", :from => "Time zone"
    click_button "Save"

    # Grab the tracking code displayed on the page.
    tracking_code = find("pre").text

    # Gets the current URL that Selenium is accessing.
    uri = URI.parse(current_url)
    uri.path = "/"

    # Replace all instances of the test URI with the Selenium one.
    tracking_code.gsub!(
      "http://snowfinch.rails.fi:3000/",
      uri.to_s
    )

    # Create an empty HTML page that contains the tracking code.
    html = <<-HTML
      <!DOCTYPE html>
      <html>
        <head><title>Tracking test</title></head>
        <body>#{tracking_code}</body>
      </html>
    HTML

    # We'll store the HTML into a tempfile. Here we define its path.
    tempfile_path = Rails.root.join("public/tracking_test.html")

    # Save the page into a file that we can navigate to.
    File.open(tempfile_path, "w") do |file|
      file.write html
    end

    # Visit the file we just saved.
    visit "/tracking_test.html"

    # Remove the temporary HTML file.
    FileUtils.rm(tempfile_path)

    # Go back to the sites page.
    visit sites_page

    # Follow the link to the site we are tracking.
    click_link "Tracking test"

    # Check if the click got registered, by checking the counters on the
    # site dashboard.
    find("div[data-counter='active_visitors'] .value").should have_content("1")
    find("div[data-counter='pageviews_today'] .value").should have_content("1")
    find("div[data-counter='visitors_today'] .value").should have_content("1")
  end
end
