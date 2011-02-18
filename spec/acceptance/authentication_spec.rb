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

    page.should have_content("Welcome, you are now signed in.")
    current_path.should == sites_page
  end

  scenario "Accessing a restricted page while signed out" do
    visit sites_page

    current_path.should == sign_in_page
    page.should have_content("You must sign in to access the requested page.")
  end

  scenario "Failed sign in" do
    visit sign_in_page
    click_button "Sign in"

    page.should have_content("Invalid email and/or password. Please try again.")
  end

  scenario "Forgotten password" do
    visit sign_in_page
    click_link "Forgot your password?"

    fill_in "Email", :with => "jason@snowfinch.net"
    click_button "Send instructions"

    page.should have_content("Password reset instructions have been emailed.")
  end

  scenario "Logging out" do
    sign_in :user

    click_link "Sign out"

    current_path.should == sign_in_page
  end

end
