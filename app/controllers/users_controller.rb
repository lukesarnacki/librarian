class UsersController < ApplicationController

  respond_to :json, :js

  def index
    @users = User.scoped
    @users = @users.search(params[:autocomplete]) if params[:autocomplete].present?
    respond_with @users
  end

  def autocomplete
    respond_with @user = User.find(params[:id])
  end
end
