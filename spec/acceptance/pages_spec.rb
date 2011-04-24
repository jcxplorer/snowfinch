require File.expand_path(File.dirname(__FILE__) + '/acceptance_helper')

feature "Pages" do

  let :site do
    site = Factory :site
  end

  background do
    sign_in :user
    Mongo.db["site_counts"].insert("s" => site.bson_id)
  end
  
  scenario "Viewing a page" do
    Mongo.db["page_counts"].insert(
      "s" => site.bson_id,
      "h" => "ddh1rWSO1CR8Bt2J6AitMv733fp",
      "u" => "http://rails.fi/"
    )

    visit site_page(site)

    fill_in "page_uri", :with => "http://rails.fi/"
    click_button "View stats"

    page.should have_title("http://rails.fi/")
    current_path.should == "/sites/#{site.id}/pages/ddh1rWSO1CR8Bt2J6AitMv733fp"
  end

  scenario "Viewing a page with no data" do
    visit site_page(site)

    fill_in "page_uri", :with => "http://rails.fi/"
    click_button "View stats"

    page.should have_title("Not found")
    page.should have_content("Sorry, there is no data for the requested page.")
  end

end
