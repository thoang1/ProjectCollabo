class ProfileController < ApplicationController
	def show
		@user = User.find_by_profile_name(params[:id])
  end
end
