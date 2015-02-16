class LandingsController < ApplicationController
	def index
    redirect_to user_path(current_user.username) if current_user
		@user = current_user
	end
end
