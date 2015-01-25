class Resource < ActiveRecord::Base
	belongs_to :collection

  validates :title, length: { minimum: 2, maximum: 255 }, allow_blank: false
	validate :url, precense: true

  scope :visible, -> { joins(:collection).where('is_visible = ?', true) }
  scope :with_thumbnail, -> { where("thumbnail <> ''" ) }

  def is_fulltext?
    self.mime == 'text' || self.mime == 'video' || self.mime == 'collcetion'
  end

  def is_title_only?
    !self.description.present? && !self.content.present? && !self.embedded_html.present?
  end

  def is_text?
    self.mime == 'text'
  end

  def is_photo?
    self.mime == 'photo'
  end

  def should_present_thumbnail?
    !self.content.present? && !self.embedded_html.present?
  end
end
