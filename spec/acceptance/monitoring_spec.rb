require File.expand_path(File.dirname(__FILE__) + '/acceptance_helper')

feature "Monitoring" do

  let :site do
    Factory :site
  end

  background do
    sign_in :user
  end

  scenario "No sensors exist" do
    visit sensors_page(site)

    message = %{You don't have any sensors. Click "Add a sensor" to create one.}
    page.should have_content(message)
  end

  scenario "Browsing sensors" do
    some  = Factory :sensor, :name => "Social Media", :site => site
    bacon = Factory :sensor, :name => "Bacon Campaign", :site => site

    visit sensors_page(site)
    
    page.should have_title("Monitoring")

    page.should have_link("Social Media", :href => sensor_page(some))
    page.should have_link("Bacon Campaign", :href => sensor_page(bacon))
  end

end
