class UsersController < ApplicationController

  respond_to :html

  navigation :users

  def index
    @users = User.order(:email)
    respond_with @users
  end

  def show
    respond_with resource
  end

  def new
    respond_with(@user = User.new)
  end

  def create
    @user = User.new(params[:user])
    if @user.save
      flash.notice = %{"#{@user.email}" has been added.}
    end
    respond_with @user, :location => users_path
  end

  def destroy
    resource.destroy
    flash.notice = %{"#{@user.email}" has been removed."}
    respond_with resource
  end

  private

  def resource
    @user ||= User.find(params[:id])
  end

end
