class CoursesController < ApplicationController
	before_action :authenticate_user!, except: [:index, :show]
	before_action :get_user
  before_action :get_course, only: [:show, :edit, :update, :destroy]

  def index
    @courses = Course.order(:created_at).page params[:page]
    respond_to do |format|
      format.html {}
      format.js {}
    end
  end

  def show
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
  end

  def update
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

  def destroy
    @course.delete
    redirect_to :root
  end

  private
  def get_course
    @course = Course.find params[:id]    
  end

  def get_user
  	@user = current_user
  end

  def create_params
    params.require(:course).permit(:name, :description, :difficulty)
  end
end
