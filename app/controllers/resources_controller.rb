require 'embedly'
require 'json'

class ResourcesController < ApplicationController
	before_action :get_course, only: [:new, :show, :create, :destroy]
	before_action :get_resource, only: [:show, :destroy]

	def new
		@mime = params[:mime]
		@resource = Resource.new
	end

	def show
	end

	def create
		p params
		@resource = @course.resources.build(create_params)
		create_and_append_embed(@resource) unless @resource.mime == 'text'

		@course.save
		redirect_to edit_course_url(@course.id)
	end

	def destroy
		@deleted_id = nil
		respond_to do |format|
			if @course.resources.delete(@resource)
				@deleted_id = @resource.id
				format.js {}
			else
				format.js { render status: :unprocessable_entity }
			end
		end
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
	def get_course
		@course = Course.find params[:course_id]
	end

	def get_resource
		@resource = Resource.find params[:id]
	end

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
