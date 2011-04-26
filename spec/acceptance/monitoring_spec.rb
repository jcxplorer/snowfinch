require File.expand_path(File.dirname(__FILE__) + '/acceptance_helper')

feature "Monitoring" do

  let(:site) { Factory :site }

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

    visit site_page(site)
    click_link "Monitoring"

    page.should have_title("Monitoring")
    page.should have_active_navigation("Sites")
    current_path.should == sensors_page(site)

    page.should have_link("Social Media", :href => sensor_page(some))
    page.should have_link("Bacon Campaign", :href => sensor_page(bacon))
  end

  scenario "Creating a query based sensor" do
    visit sensors_page(site)
    click_link "Add a sensor"

    page.should have_title("Add a sensor")
    page.should have_active_navigation("Sites")
    current_path.should == new_sensor_page(site)
    
    within "#query_sensor_form" do
      fill_in "Sensor name", :with => "Summer Discount"
      fill_in "URI query key", :with => "campaign"
      fill_in "URI query value", :with => "summer_discount"
      click_button "Save"
    end

    page.should have_notice('"Summer Discount" has been created.')

    current_path.should == sensor_page(Sensor.last)
  end

  scenario "Creating a host based sensor", :js => true do
    visit new_sensor_page(site)

    click_link "Referrer based"

    within "#referrer_sensor_form" do
      fill_in "Sensor name", :with => "Social Media"
      fill_in "Referrer host", :with => "facebook.com"
      click_link "Add"
      fill_in "Referrer host", :with => "twitter.com"
      click_link "Add"
      click_button "Save"
    end

    page.should have_notice('"Social Media" has been created.')

    current_path.should == sensor_page(Sensor.last)

    # It's a complex form with JavaScript manipulating nested attributes. This
    # is the easiest way to make sure the hosts get created.
    Sensor.last.hosts.count.should == 2
    Sensor.last.hosts.where(:host => "facebook.com").count.should == 1
    Sensor.last.hosts.where(:host => "twitter.com").count.should == 1
  end

  scenario "Toggling between query and host creation forms", :js => true do
    visit new_sensor_page(site)
    
    page.should have_title("Add a sensor")

    find("#query_sensor_form").should be_visible
    find("#referrer_sensor_form").should_not be_visible
    page.should have_css("#query_based_toggle.active")
    page.should_not have_css("#referrer_based_toggle.active")

    click_link "Referrer based"
    find("#query_sensor_form").should_not be_visible
    find("#referrer_sensor_form").should be_visible
    page.should_not have_css("#query_based_toggle.active")
    page.should have_css("#referrer_based_toggle.active")

    click_link "Query based"
    find("#query_sensor_form").should be_visible
    find("#referrer_sensor_form").should_not be_visible
    page.should have_css("#query_based_toggle.active")
    page.should_not have_css("#referrer_based_toggle.active")
  end

  scenario "Viewing a sensor" do
    sensor = Factory :sensor, :name => "SoMe", :site => site
    
    visit sensor_page(sensor)

    page.should have_title("SoMe")
    page.should have_active_navigation("Sites")
  end

  scenario "Editing a query based sensor" do
    sensor = Factory :sensor,
                     :name => "FR10",
                     :type => "query",
                     :uri_query_key => "campaign",
                     :uri_query_value => "fr10",
                     :site => site

    visit sensor_page(sensor)
    click_link "Edit"

    fill_in "Sensor name", :with => "FR11"
    fill_in "URI query value", :with => "fr11"
    click_button "Save"

    page.should have_notice(%{"FR11" has been updated.})
    current_path.should == sensor_page(sensor)
    page.should have_title("FR11")
  end

  scenario "Editing a host based sensor" do
    pending
  end

  scenario "Removing a sensor" do
    pending
  end

end
