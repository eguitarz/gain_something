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
    @course.user = current_user
    @course.save
    redirect_to edit_course_path(@course.id)
  end

  def edit
    @course = Course.find params[:id]
  end

  def update
    @course = Course.find params[:id]

    respond_to do |format|
      if @course.update(create_params)
        format.html { redirect_to action: :edit }
        format.js {}
      else
        format.html { redirect_to action: :edit }
        format.js { render status: :unprocessable_entity }
      end
    end
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
    params.require(:course).permit(:name, :description, :difficulty)
  end
end
