class CollectionsController < ApplicationController
  before_action :get_user
  before_action :get_collection, only: [:show, :edit, :update, :destroy, :toggle_visibility, :sort]
  before_action only: [:edit, :update, :destroy, :toggle_visibility, :sort] do
    require_owner @collection.user
  end
  before_action :require_user_signed_in, except: [:index, :show]
  before_action :check_visibility, only: [:show]
  before_action :user_owned_collections, only: [:show]

  def index
    # @collections = Collection.order(updated_at: :desc).page params[:page]
    # respond_to do |format|
    #   format.html {}
    #   format.js {}
    # end
    if current_user.present?
      redirect_to user_path(current_user.username)
    else
      redirect_to new_user_session_path
    end
  end

  def show
    @is_preview = params[:p] || false
    @resource_index = (params[:idx] || -1).to_i
    @resources = @collection.resources.order(:priority, :created_at)
    @current_resource = @resources[@resource_index] if @resource_index >= 0 && @resource_index < @resources.length
  end

  def new
    @collection = Collection.new
  end

  def create
    @collection = Collection.new create_params
    @collection.user = current_user
    if @collection.save
      redirect_to collection_path(@collection.id)
    else
      flash[:error] = @collection.errors.full_messages.join(', ')
      redirect_to :back
    end
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

  def toggle_visibility
    begin
      @collection.toggle! :is_visible
    rescue => e
      puts e
    end
    visibility = @collection.is_visible?

    respond_to do |format|
      format.js {}
    end
  end

  def sort
    if params[:resource].present? && params[:resource].kind_of?(Array)
      params[:resource].each_with_index do |id, i|
        @collection.find_resource(id).first.update_attribute(:priority, i)
      end
    end

    respond_to do |format|
      format.js { render }
    end
  end

  private
  def get_collection
    begin
      @collection = Collection.find params[:id] || params[:collection_id]  
    rescue => e
      puts e
      redirect_to :root
    end
  end

  def get_user
    @user = current_user
  end

  def create_params
    params.require(:collection).permit(:name, :description, :is_visible)
  end

  def check_visibility
    if !@collection.is_visible? && (!current_user.present? || @collection.user.id != current_user.id)
      flash[:notice] = 'This collection is private, only author can access it.'
      redirect_to :root
    end
  end

  def user_owned_collections
    @owned_collections = current_user.collections
  end
end