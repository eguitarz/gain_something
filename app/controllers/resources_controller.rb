class ResourcesController < ApplicationController

	def new
		@course = Course.find params[:course_id]
		@mime = params[:mime]
		@resource = Resource.new
	end

	def show
		@resource = Resource.find params[:id]
		@resource.description = CoursesHelper::markdown_to_html(@resource.description)
	end

	def create
		@course = Course.find params[:course_id]
		@resource = @course.resources.build(create_params)

		@course.save
		redirect_to edit_course_url(@course.id)
	end

	private
	def create_params
		params.require(:resource).permit(:title, :url, :third_party_id, :mime, :description)
	end
end
