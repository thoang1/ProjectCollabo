class UsersController < ApplicationController
	def show
    @user = User.find_by_profile_name(params[:id])
  end

  def index 
  	@users = User.all
  end

  def edit
    @user = current_user
  end

 def update
    @user = User.find_by_profile_name(params[:id])
    @user.update(user_params)
    redirect_to @user
	end

  def user_params
      params.require(:user).permit(:about_me, :hobbies, :country, :gender)
  end
end

