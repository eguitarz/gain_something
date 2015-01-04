class Resource < ActiveRecord::Base
	belongs_to :collection

  validates :title, length: { minimum: 3, maximum: 255 }, allow_blank: false
	validate :url, precense: true
end
