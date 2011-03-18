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

  scenario "Creating a query based sensor" do
    visit new_sensor_page(site)
    
    within "#query_based" do
      fill_in "Sensor name", :with => "Summer Discount"
      fill_in "URI query key", :with => "campaign"
      fill_in "URI query value", :with => "summer_discount"
      click_button "Save"
    end

    page.should have_notice('"Summer Discount" has been created.')

    current_path.should == sensor_page(Sensor.last)
  end

  scenario "Creating a host based sensor" do
    visit new_sensor_page(site)

    within "#host_based" do
      fill_in "Sensor name", :with => "Social Media"
      fill_in "Host", :with => "facebook.com"
      click_link "Add another host"
      pending
    end
  end

  scenario "Toggling between query and host based sensors during creation" do
    visit new_sensor_page(site)

    find("#query_based").should be_visible
    pending
  end

end
