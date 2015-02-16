class Users::RegistrationsController < Devise::RegistrationsController
  include ApplicationHelper

  def create
    super
    resource.collections << Collection.create({name: "#{@user.username}'s inbox", description: 'My first collection'})
    resource.save
    # redirect_to :back unless resource.save
  end

  def new
    super
  end

  def edit
    super
  end
end
