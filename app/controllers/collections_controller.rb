class CollectionsController < ApplicationController
  before_action :authenticate_user!, except: [:index, :show]
  before_action :get_user
  before_action :get_collection, only: [:show, :edit, :update, :destroy]

  def index
    @collections = Collection.order(updated_at: :desc).page params[:page]
    respond_to do |format|
      format.html {}
      format.js {}
    end
  end

  def show
    @is_preview = params[:p] || false
    @resource_index = params[:idx] || -1
    @resource_index = @resource_index.to_i
    @resources = @collection.resources.order(updated_at: :desc)
    @current_resource = @resources[@resource_index] if @resource_index >= 0 && @resource_index < @resources.length
  end

  def new
    @collection = Collection.new
  end

  def create
    @collection = Collection.new create_params
    @collection.user = current_user
    @collection.save
    redirect_to collection_path(@collection.id)
  end

  def edit
  end

  def update
    respond_to do |format|
      if @collection.update(create_params)
        format.html { redirect_to action: :show }
        format.js {}
      else
        format.html { redirect_to action: :show }
        format.js { render status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @collection.delete
    redirect_to :root
  end

  private
  def get_collection
    @collection = Collection.find params[:id]    
  end

  def get_user
    @user = current_user
  end

  def create_params
    params.require(:collection).permit(:name, :description, :difficulty)
  end
end