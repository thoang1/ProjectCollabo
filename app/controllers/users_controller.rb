class UsersController < ApplicationController
	before_filter :authenticate_user!, only: [ :new, :create, :edit, :update, :destroy ]
	def show
    @user = User.find_by_profile_name(params[:id]) 
    if (@user)
			render action: :show
    else
      render file: 'public/404', status: 404, formats: [:html]
    end
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

  def following
    @title = "Following"
    @user = User.find_by_profile_name(params[:id])
    @users = @user.followed_users
    render 'show_follow'
  end

  def followers
    @title = "Followers"
    @user = User.find_by_profile_name(params[:id])
    @users = @user.followers
    render 'show_follow'
  end

  def user_params
      params.require(:user).permit(:about_me, :hobbies, :country, :gender)
  end
end

