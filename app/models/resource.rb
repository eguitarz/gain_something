class Resource < ActiveRecord::Base
	belongs_to :collection

  validates :title, length: { minimum: 3, maximum: 255 }, allow_blank: false
  validates :description, length: { maximum: 140 }
	validate :url, precense: true
end
