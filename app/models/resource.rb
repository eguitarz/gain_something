class Resource < ActiveRecord::Base
	belongs_to :collection

  validates :title, length: { minimum: 2, maximum: 255 }, allow_blank: false
	validate :url, precense: true

  def is_fulltext?
    self.mime == 'text' || self.mime == 'video' || self.mime == 'collcetion'
  end
end
