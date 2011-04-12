require File.expand_path(File.dirname(__FILE__) + '/acceptance_helper')

feature "Authentication" do

  background do
    Factory :user, :email => "jason@snowfinch.net", :password => "123456"
  end

  scenario "Signing in" do
    visit sign_in_page

    fill_in "Email", :with => "jason@snowfinch.net"
    fill_in "Password", :with => "123456"
    click_button "Sign in"

    page.should have_notice("Welcome, you are now signed in.")
    current_path.should == sites_page
  end

  scenario "Accessing a restricted page while signed out" do
    visit sites_page

    current_path.should == sign_in_page
    page.should have_notice("You must sign in to access the requested page.")
  end

  scenario "Failed sign in" do
    visit sign_in_page
    click_button "Sign in"

    page.should have_notice("Invalid email and/or password. Please try again.")
  end

  scenario "Logging out" do
    sign_in :user

    click_link "Sign out"

    current_path.should == sign_in_page
  end

end
