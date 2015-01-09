class UsersController < ApplicationController
	def show
		@user = User.where(username: params[:username]).first

    if @user.present?
      @collections = @user.collections.order(:name).page params[:page]
      respond_to do |format|
        format.html {}
        format.js { render partial: 'collections/load_more' }
      end
    else
      redirect_to :root 
    end
	end
end
