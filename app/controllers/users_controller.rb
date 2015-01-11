class UsersController < ApplicationController

	def show
		@user = User.where(username: params[:username]).first

    if @user.present?
      if @user.id == current_user.id
        @collections = @user.collections.order(:name).page params[:page]
      else
        @collections = @user.collections.visible.order(:name).page params[:page]
      end

      respond_to do |format|
        format.html {}
        format.js { render partial: 'collections/load_more' }
      end
    else
      redirect_to :root 
    end
	end
end
