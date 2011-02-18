require File.expand_path(File.dirname(__FILE__) + '/acceptance_helper')

feature "Navigation" do

  scenario "Signed out" do
    visit sign_in_page
    page.all("body > header nav ul li").should be_empty
  end

  scenario "Signed in" do
    sign_in :user

    within "body > header nav" do
      page.should have_link("Sites")
      page.should have_link("Users")
    end
  end

end
