class AccountsController < ApplicationController
  respond_to :html
  navigation :account

  def edit
    respond_with user
  end

  def update
    if user.update_with_password(params[:user])
      sign_in(user, :bypass => true)
      flash.notice = "Your account has been updated."
    end
    respond_with user, :location => :root
  end

  private

  def user
    @user ||= current_user
  end
end
