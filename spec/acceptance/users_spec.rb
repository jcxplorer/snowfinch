require File.expand_path(File.dirname(__FILE__) + '/acceptance_helper')

feature "Users" do

  background do
    @joe = sign_in :user, :email => "joe@snowfinch.net"
  end

  scenario "Browsing users" do
    aaron = Factory :user, :email => "aaron@snowfinch.net"
    ted   = Factory :user, :email => "ted@snowfinch.net"

    visit users_page
    
    page.should have_title("Users")
    page.should have_active_navigation("Users")

    page.should have_link("joe@snowfinch.net", :href => user_page(@joe))
    page.should have_link("aaron@snowfinch.net", :href => user_page(aaron))
    page.should have_link("ted@snowfinch.net", :href => user_page(ted))

    page.all("ul.list a").map(&:text).should ==
      ["aaron@snowfinch.net", "joe@snowfinch.net", "ted@snowfinch.net"]
  end

  scenario "Viewing a user" do
    visit user_page(@joe)

    page.should have_title("joe@snowfinch.net")
    page.should have_active_navigation("Users")
  end

  scenario "Adding a user" do
    visit users_page
    click_link "Add a user"

    current_path.should == new_user_page
    page.should have_title("Add a user")
    page.should have_active_navigation("Users")

    page.should have_content("The user will receive an email with a password.")
    
    fill_in "Email", :with => "jack@snowfinch.net"
    click_button "Add"

    page.should have_notice('"jack@snowfinch.net" has been added.')
    current_path.should == users_page
  end

  scenario "Removing a user" do
    luke = Factory :user, :email => "luke@snowfinch.net"

    visit user_page(luke)
    click_button "Remove this user"

    page.should have_notice('"luke@snowfinch.net" has been removed.')
    current_path.should == users_page
  end

end
