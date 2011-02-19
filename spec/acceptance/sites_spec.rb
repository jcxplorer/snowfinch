require File.expand_path(File.dirname(__FILE__) + '/acceptance_helper')

feature "Sites" do

  background do
    sign_in :user
  end

  scenario "Browsing sites" do
    blog = Factory :site, :name => "Blog"
    api  = Factory :site, :name => "API docs"
    info = Factory :site, :name => "Info"

    visit sites_page

    page.should have_title("Sites")
    page.should have_active_navigation("Sites")

    page.should have_link("API docs", :href => site_page(api))
    page.should have_link("Blog", :href => site_page(blog))
    page.should have_link("Info", :href => site_page(info))

    page.all("ul.list a").map(&:text).should == ["API docs", "Blog", "Info"]
  end

  scenario "Adding a site" do
    visit sites_page

    click_link "Add a site"
    current_path.should == new_site_page
    page.should have_title("Add a site")
    page.should have_active_navigation("Sites")

    fill_in "Site name", :with => "Snowfinch info"
    click_button "Save"

    page.should have_notice('"Snowfinch info" has been created.')

    current_path.should == site_page(Site.last)
  end

  scenario "Viewing a site" do
    site = Factory :site, :name => "Snowfinch blog"

    visit site_page(site)

    page.should have_title("Snowfinch blog")
    page.should have_active_navigation("Sites")
  end

  scenario "Editing a site" do
    site = Factory :site, :name => "Snowfinch blog"

    visit site_page(site)
    click_link "Edit"

    page.should have_title('Edit "Snowfinch blog"')
    page.should have_active_navigation("Sites")
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
