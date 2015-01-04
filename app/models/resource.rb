class Resource < ActiveRecord::Base
	belongs_to :collection

	validate :title, precense: true
	validate :url, precense: true
	validate :third_party_id, precense: true
end
