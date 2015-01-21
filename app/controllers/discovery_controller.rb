class DiscoveryController < ApplicationController
  def index
    @resources = Resource.all.first(100)
  end
end
