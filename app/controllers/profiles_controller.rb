class ProfilesController < ApplicationController

  respond_to :html

  def show
    @user = current_user
  end

  def edit
    @user = current_user
  end

  def update
    @user = current_user

    if @user.update_attributes(user_params)
      flash[:success] = t('profiles.edit.success')
    else
      flash[:error] = t('profiles.edit.failure')
    end

    respond_with @user, location: profile_path
  end

  def reservations
  end

  private

  def user_params
    params.require(:user).permit(:name, :email, :phone)
  end
end
