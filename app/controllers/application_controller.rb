class ApplicationController < ActionController::Base

  protect_from_forgery

  before_filter :authenticate_user!

  private
  
  def user_root_path
    sites_path
  end

  def navigation(identifier)
    @navigation_id = identifier
  end

  def self.navigation(identifier)
    before_filter { navigation(identifier) }
  end

end
