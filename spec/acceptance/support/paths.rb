module NavigationHelpers

  def homepage
    "/"
  end

  def sign_in_page
    "/users/sign_in"
  end

  def sites_page
    "/sites"
  end

end

RSpec.configuration.include NavigationHelpers, :type => :acceptance
