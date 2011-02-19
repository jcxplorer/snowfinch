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

  def site_page(site)
    "/sites/#{site.id}"
  end

  def new_site_page
    "/sites/new"
  end

  def edit_site_page(site)
    "/sites/#{site.id}/edit"
  end

  def users_page
    "/users"
  end

end

RSpec.configuration.include NavigationHelpers, :type => :acceptance
