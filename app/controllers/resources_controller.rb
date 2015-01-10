require 'embedly'
require 'json'

RESOURCE_LIMIT = 150

class ResourcesController < ApplicationController
	before_action :get_collection, only: [:new, :show, :create, :edit, :update, :destroy]
	before_action :get_resource, only: [:show, :destroy, :edit]
	before_action only: [:new, :create, :edit, :update, :destroy] do
    require_owner @collection.user
  end
	before_action :require_user_signed_in, except: [:show]
	before_action :check_resources_limit, only: [:new, :create]

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
		@resource = @collection.resources.build(resource_params)
		create_and_append_embed(@resource) unless @resource.mime == 'text'

		if @resource.mime == 'error'
			flash[:error] = 'Some error happend while fetching your resource'
		end
		
		unless @collection.save
			flash[:error] = [@collection.errors.full_messages.join(', '), @resource.errors.full_messages.join(', ')].join(', ')
		end

		redirect_to collection_url(@collection.id)
	end

	def edit
		@mime = @resource.mime
		redirect_to collection_resource_url(@collection.id) if @mime != 'text'
	end

	def update
		@resource = Resource.find params[:id] 
		@resource.update resource_params

		redirect_to collection_url(@collection.id)
	end

	def destroy
		@deleted_id = nil
		respond_to do |format|
			if @collection.resources.delete(@resource)
				@deleted_id = @resource.id
				format.js {}
				format.html { redirect_to collection_url(@collection.id) }
			else
				format.js { render status: :unprocessable_entity }
				format.html { redirect_to collection_url(@collection.id) }
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
	def get_collection
		begin
			@collection = Collection.find params[:collection_id]
		rescue
			redirect_to :root
		end
	end

	def get_resource
		begin
			@resource = Resource.find params[:id]
		rescue
			redirect_to :root
		end
	end

	def resource_params
		params.require(:resource).permit(:title, :url, :mime, :description, :provider_name, 
			:provider_url, :thumbnail, :thumbnail_width)
	end

	def create_and_append_embed(resource)
		embed = create_embed_by_url(resource.url)
		resource.title = embed[:title].first(255)
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

	def check_resources_limit
	  if @collection.resources.count >= RESOURCE_LIMIT
	    flash[:error] = "Reached the limit of resources: #{RESOURCE_LIMIT}"
	    redirect_to :back
	  end
	end
end
