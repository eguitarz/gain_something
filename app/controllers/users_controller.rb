class UsersController < ApplicationController
	def show
		@user = User.find params[:id]
    @collections = Collection.order(updated_at: :desc).page params[:page]
    respond_to do |format|
      format.html {}
      format.js {}
    end
	end
end
