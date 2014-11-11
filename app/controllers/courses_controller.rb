class CoursesController < ApplicationController
	before_filter :authenticate_user!, except: [:index, :show]
	before_filter :get_user

  def index
    @courses = Course.all
  end

  def show
    @course = Course.find params[:id]
  end

  def new
  	@course = Course.new
  end

  def create
    @course = Course.new create_params
    @course.save
    redirect_to edit_course_path(@course.id)
  end

  def edit
    @course = Course.find params[:id]
  end

  def update
  end

  def new_text
  end

  def new_link
  end

  def new_video
  end

  def new_file
  end

  private
  def get_user
  	@user = current_user
  end

  def create_params
    params.require(:course).permit(:name, :description)
  end
end
