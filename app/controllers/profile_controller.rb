class ProfileController < ApplicationController
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
    respond_to do |format|
    	@user = User.find_by_profile_name(params[:id])
      if @user.update(user_params)
       format.html { redirect_to user_path, notice: 'User was successfully updated.' }
      else
      format.html { render action: "edit" }
     	end
  	end
	end
end
