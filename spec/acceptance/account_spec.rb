require File.expand_path(File.dirname(__FILE__) + '/acceptance_helper')

feature "Account" do

  background do
    sign_in :user, :email => "user@snowfinch.net", :password => "snowfinch"
  end

  scenario "Edit own account" do
    visit homepage
    click_link "Account"

    page.should have_active_navigation("Account")
    page.should have_title("Account")
    
    fill_in "Email", :with => "joao@snowfinch.net"
    fill_in "Password", :with => "joaojoao"
    fill_in "Password confirmation", :with => "joaojoao"
    fill_in "Current password", :with => "snowfinch"
    click_button "Save"

    page.should have_notice("Your account has been updated.")
    current_path.should == homepage

    click_link "Sign out"

    fill_in "Email", :with => "joao@snowfinch.net"
    fill_in "Password", :with => "joaojoao"
    click_button "Sign in"

    page.should have_notice("Welcome, you are now signed in.")
  end

end
