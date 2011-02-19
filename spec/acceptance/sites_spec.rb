require File.expand_path(File.dirname(__FILE__) + '/acceptance_helper')

feature "Sites" do

  background do
    sign_in :user
  end

  scenario "Browsing sites" do
    blog = Factory :site, :name => "Snowfinch blog"
    dev  = Factory :site, :name => "Snowfinch developer"

    visit sites_page

    page.should have_title("Sites")
    page.should have_active_navigation("Sites")

    page.should have_link("Snowfinch blog", :href => site_page(blog))
    page.should have_link("Snowfinch developer", :href => site_page(dev))
  end

  scenario "Adding a site" do
    visit sites_page

    click_link "Add a site"
    current_path.should == new_site_page
    page.should have_title("Add a site")

    fill_in "Site name", :with => "Snowfinch info"
    click_button "Save"

    page.should have_notice('"Snowfinch info" has been created.')

    current_path.should == site_page(Site.last)
  end

  scenario "Viewing a site" do
    site = Factory :site, :name => "Snowfinch blog"

    visit site_page(site)

    page.should have_title("Snowfinch blog")
  end

  scenario "Editing a site" do
    site = Factory :site, :name => "Snowfinch blog"

    visit site_page(site)
    click_link "Edit"

    page.should have_title('Edit "Snowfinch blog"')
    current_path.should == edit_site_page(site)

    fill_in "Site name", :with => "Snowfinch development blog"
    click_button "Save"

    page.should have_notice('"Snowfinch development blog" has been updated.')

    current_path.should == site_page(site)
  end

  scenario "Failed editing" do
    site = Factory :site, :name => "Snowfinch info"

    visit edit_site_page(site)

    fill_in "Site name", :with => ""
    click_button "Save"

    page.should have_title('Edit "Snowfinch info"')
  end

  scenario "Removing a site" do
    site = Factory :site, :name => "Old Snowfinch blog"

    visit edit_site_page(site)
    click_button "Remove this site"

    page.should have_notice('"Old Snowfinch blog" has been removed.')
    current_path.should == sites_page
  end

  scenario "No sites exist" do
    visit sites_page

    message = %{You don't have any sites. Click "Add a site" to create one.}
    page.should have_content(message)
  end

end
