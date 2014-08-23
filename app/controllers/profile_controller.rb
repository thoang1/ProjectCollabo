class ProfileController < ApplicationController
	before_filter :authenticate_user!
	def show
		@user = User.find_by_profile_name(params[:id])
  end
end
