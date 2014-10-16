class CoursesController < ApplicationController
	before_filter :authenticate_user!, except: [:index, :show]
	before_filter :get_user

  def index
  end

  def show
  end

  def new
  	@course = Course.new
  end

  private
  def get_user
  	@user = current_user
  end
end
