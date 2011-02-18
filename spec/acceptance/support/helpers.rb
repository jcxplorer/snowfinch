module HelperMethods

  def sign_in(resource_name, factory_opts={})
    resource = Factory(resource_name, factory_opts)

    visit sign_in_page
    fill_in "Email", :with => resource.email
    fill_in "Password", :with => resource.password
    click_button "Sign in"

    resource
  end

end

RSpec.configuration.include HelperMethods, :type => :acceptance
