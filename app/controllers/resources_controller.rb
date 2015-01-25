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
		@resource.extract unless @resource.mime == 'text'

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

	def check_resources_limit
	  if @collection.resources.count >= RESOURCE_LIMIT
	    flash[:error] = "Reached the limit of resources: #{RESOURCE_LIMIT}"
	    redirect_to :back
	  end
	end

end
