class Resource < ActiveRecord::Base
	belongs_to :collection

  validates :title, length: { minimum: 2, maximum: 255 }, allow_blank: false
	validate :url, precense: true

  scope :visible, -> { joins(:collection).where('is_visible = ?', true) }
  scope :with_thumbnail, -> { where("thumbnail <> ''" ) }

  def is_fulltext?
    self.mime == 'text' || self.mime == 'video' || self.mime == 'collcetion'
  end
end
