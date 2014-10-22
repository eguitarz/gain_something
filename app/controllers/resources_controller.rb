class ResourcesController < ApplicationController

	def new
		@course = Course.find params[:course_id]
		@resource = Resource.new
	end

	def create
		@course = Course.find params[:course_id]
		@resource = @course.resources.build(create_params)

		@course.save
		redirect_to course_url(@course.id)
	end

	private
	def create_params
		params.require(:resource).permit(:title, :mime, :description)
	end
end
