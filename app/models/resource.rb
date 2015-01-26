class Resource < ActiveRecord::Base
  EMBEDLY_KEY = 'b782de7414f440b5bf31d9c76409acf9'

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

  def is_link?
    self.mime == 'link'
  end

  def is_photo?
    self.mime == 'photo'
  end

  def should_present_thumbnail?
    !self.content.present? && !self.embedded_html.present?
  end

  def extract
    extraction = extract_from_url(self.url)
    self.title = extraction[:title].first(255)
    self.embedded_html = extraction[:html]
    self.mime = extraction[:type] == 'html' ? 'link' : extraction[:type]
    self.provider_name = extraction[:provider_name]
    self.provider_url = extraction[:provider_url]
    self.description = extraction[:description]
    self.content = extraction[:content]

    if extraction[:images] && !extraction[:media].empty?
      image = extraction[:images].first
      if image.present?
        self.thumbnail = image['url']
        self.thumbnail_width = image['width']
        self.thumbnail_height = image['height']
      end
    end

    if extraction[:media] && !extraction[:media].empty?
      media = extraction[:media]
      if media.present?
        self.mime = media.type if media.type.present?
        self.embedded_html = media.html if media.html.present?
      end
    end

  end

  private
  def create_embed_by_url(url)
    embedly_api = Embedly::API.new key: EMBEDLY_KEY
    obj = embedly_api.oembed :url => url
    {
      html: obj[0]['html'],
      url: url,
      title: obj[0]['title'] || url,
      type: obj[0]['type']  || 'unknown',
      provider_name: obj[0]['provider_name'],
      provider_url: obj[0]['provider_url'],
      thumbnail: obj[0]['thumbnail_url'],
      thumbnail_width: obj[0]['thumbnail_width'],
      description: obj[0]['description']
    }
  end

  def extract_from_url(url)
    embedly_api = Embedly::API.new key: EMBEDLY_KEY
    extracted_obj = embedly_api.extract(:url => url)[0]
    {
      html: extracted_obj['html'],
      title: extracted_obj['title'] || url,
      url: url,
      type: extracted_obj['type']  || 'unknown',
      provider_name: extracted_obj['provider_name'],
      provider_url: extracted_obj['provider_url'],
      images: extracted_obj['images'],
      media: extracted_obj['media'],
      description: extracted_obj['description'],
      content: extracted_obj['content'],
      type: extracted_obj['type']  || 'unknown'
    }
  end
end
