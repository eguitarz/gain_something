class Resource < ActiveRecord::Base
	belongs_to :course

	validate :title, precense: true
	validate :url, precense: true
	validate :third_party_id, precense: true
end
