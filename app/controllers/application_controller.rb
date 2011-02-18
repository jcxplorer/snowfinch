class ApplicationController < ActionController::Base

  protect_from_forgery

  before_filter :authenticate_user!

  private
  
  def user_root_path
    sites_path
  end

end
