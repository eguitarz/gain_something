class DiscoveryController < ApplicationController
  def index
    @resources = Resource.visible.first(100)
  end
end
