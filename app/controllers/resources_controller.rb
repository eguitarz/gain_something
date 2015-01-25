require 'embedly'
require 'json'

RESOURCE_LIMIT = 150

class ResourcesController < ApplicationController
	before_action :get_collection, only: [:new, :create, :edit, :update, :destroy, :change_parent]
	before_action :get_resource, only: [:destroy, :edit, :change_parent, :copy]
	before_action only: [:new, :create, :edit, :update, :destroy, :change_parent] do
    require_owner @collection.user
  end
	before_action :require_user_signed_in
	before_action :check_resources_limit, only: [:new, :create]

	def new
		@mime = params[:mime]
		@resource = Resource.new
	end

	def create
		@resource = @collection.resources.build(resource_params)
		@collection.touch
		extract(@resource) unless @resource.mime == 'text'

		if @resource.mime == 'error'
			flash[:error] = 'Some error happend while fetching your resource'
		end
		
		unless @collection.save
			flash[:error] = [@collection.errors.full_messages.join(', '), @resource.errors.full_messages.join(', ')].join(', ')
		end

		redirect_to collection_url(@collection.id)
	end

	def edit
		respond_to do |format|
			format.html {}
			format.js {}
		end
	end

	def update
		@resource = Resource.find params[:id] 
		@resource.update resource_params

		respond_to do |format|
			format.html { redirect_to collection_url(@collection.id) }
			format.js {}
		end
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

	def change_parent
		new_collection_id = params[:new_collection_id]

		if new_collection_id
			new_collection = Collection.find new_collection_id
			
			if new_collection.present? && new_collection.belongs_to?(current_user)
				@resource.update_attribute(:collection_id, new_collection.id)
			end
		end

		respond_to do |format|
			format.js {render 'resources/move.js.haml', locals: {resource_id: @resource.id} }
		end
	end

	def copy
		new_collection_id = params[:new_collection_id]

		if new_collection_id
			@new_collection = Collection.find new_collection_id
			
			if @new_collection.present? && @new_collection.belongs_to?(current_user)
				new_resource = Resource.new @resource.attributes.except('id', 'collection_id')
				new_resource.collection_id = @new_collection.id
				new_resource.save
			end
		end

		respond_to do |format|
			format.js {render 'resources/copy.js.haml', locals: {resource_id: @resource.id} }
		end
	end

	private
	def get_collection
		begin
			@collection = Collection.find params[:collection_id]
		rescue => e
			puts e
			redirect_to :root
		end
	end

	def get_resource
		begin
			@resource = Resource.find params[:id] || params[:resource_id]
		rescue => e
			puts e
			redirect_to :root
		end
	end

	def resource_params
		params.require(:resource).permit(:title, :url, :mime, :description, :provider_name, 
			:provider_url, :thumbnail, :thumbnail_width)
	end

	def extract(resource)
		extraction = extract_from_url(resource.url)
		resource.title = extraction[:title].first(255)
		resource.embedded_html = extraction[:html]
		resource.mime = extraction[:type] == 'html' ? 'link' : extraction[:type]
		resource.provider_name = extraction[:provider_name]
		resource.provider_url = extraction[:provider_url]
		resource.description = extraction[:description]
		resource.content = extraction[:content]

		if extraction[:images] && !extraction[:media].empty?
			image = extraction[:images].first
			if image.present?
				resource.thumbnail = image['url']
				resource.thumbnail_width = image['width']
				resource.thumbnail_height = image['height']
			end
		end

		p extraction
		if extraction[:media] && !extraction[:media].empty?
			media = extraction[:media]
			if media.present?
				resource.mime = media.type
				resource.embedded_html = media.html
			end
		end

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

	def extract_from_url(url)
		embedly_api = Embedly::API.new key: 'b782de7414f440b5bf31d9c76409acf9'
		extracted_obj = embedly_api.extract(:url => url)[0]
		{
			html: extracted_obj['html'],
			title: extracted_obj['title'] || url,
			url: url,
			type: extracted_obj['type']  || 'unknown',
			provider_name: extracted_obj['provider_name'],
			provider_url: extracted_obj['provider_url'],
			images: extracted_obj['images'],
			media: extracted_obj['media'],
			description: extracted_obj['description'],
			content: extracted_obj['content'],
			type: extracted_obj['type']  || 'unknown'
		}
	end

	def check_resources_limit
	  if @collection.resources.count >= RESOURCE_LIMIT
	    flash[:error] = "Reached the limit of resources: #{RESOURCE_LIMIT}"
	    redirect_to :back
	  end
	end

end
