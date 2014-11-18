require 'embedly'
require 'json'

class ResourcesController < ApplicationController

	def new
		@course = Course.find params[:course_id]
		@mime = params[:mime]
		@resource = Resource.new
	end

	def show
		@course = Course.find params[:course_id]
		@resource = Resource.find params[:id]
		@resource.description = CoursesHelper::markdown_to_html(@resource.description)
	end

	def create
		@course = Course.find params[:course_id]
		@resource = @course.resources.build(create_params)
		create_and_append_embed(@resource) if @resource.mime != 'text'

		@course.save
		redirect_to edit_course_url(@course.id)
	end

	def preview
		respond_to do |format|
			format.json { 
				begin
					url = params.fetch(:url)
					render json: create_embed_by_url(params[:url])
				rescue
					render json: {error: 'url is required'}
				end
				
			}
		end
	end

	private
	def create_params
		params.require(:resource).permit(:title, :url, :third_party_id, :mime, :description)
	end

	def create_and_append_embed(resource)
		embed = create_embed_by_url(resource.url)
		resource.title = embed[:title]
		resource.description = embed[:description]
		resource.embedded_html = embed[:html]
	end

	def create_embed_by_url(url)
		embedly_api = Embedly::API.new key: 'b782de7414f440b5bf31d9c76409acf9'
		obj = embedly_api.oembed :url => url

		{
			html: obj[0]['html'],
			url: url,
			title: obj[0]['title'],
			description: obj[0]['description']
		}
	end
end
