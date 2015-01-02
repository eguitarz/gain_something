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
		respond_to do |format|
			format.html {}
			format.js {}
		end
	end

	def create
		@resource = @course.resources.build(create_params)
		create_and_append_embed(@resource) unless @resource.mime == 'text'

		if @resource.mime == 'error'
			flash[:error] = 'Some error happend while fetching your resource'
		end
		@course.save

		redirect_to course_url(@course.id)
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
		params.require(:resource).permit(:title, :url, :mime, :description, :provider_name, 
			:provider_url, :thumbnail, :thumbnail_width)
	end

	def create_and_append_embed(resource)
		embed = create_embed_by_url(resource.url)
		resource.title = embed[:title]
		resource.embedded_html = embed[:html]
		resource.mime = embed[:type]
		resource.provider_name = embed[:provider_name]
		resource.provider_url = embed[:provider_url]
		resource.thumbnail = embed[:thumbnail]
		resource.thumbnail_width = embed[:thumbnail_width]
		resource.description = embed[:description]
	end

	def create_embed_by_url(url)
		embedly_api = Embedly::API.new key: 'b782de7414f440b5bf31d9c76409acf9'
		obj = embedly_api.oembed :url => url
		{
			html: obj[0]['html'],
			url: url,
			title: obj[0]['title'] || url,
			type: obj[0]['type']  || 'unknown',
			provider_name: obj[0]['provider_name'],
			provider_url: obj[0]['provider_url'],
			thumbnail: obj[0]['thumbnail_url'],
			thumbnail_width: obj[0]['thumbnail_width'],
			description: obj[0]['description']
		}
	end
end
