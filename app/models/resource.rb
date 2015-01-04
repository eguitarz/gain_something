class Resource < ActiveRecord::Base
	belongs_to :collection

	validate :title, precense: true
	validate :url, precense: true
end
