class Resource < ActiveRecord::Base
  EMBEDLY_KEY = 'b782de7414f440b5bf31d9c76409acf9'

	belongs_to :collection

  validates :title, length: { minimum: 2, maximum: 255 }, allow_blank: false
	validate :url, precense: true

  scope :visible, -> { joins(:collection).where('is_visible = ?', true) }
  scope :with_thumbnail, -> { where("thumbnail <> ''" ) }

  after_update :touch_collection
  after_create :touch_collection

  def is_fulltext?
    self.mime == 'text' || self.mime == 'video' || self.mime == 'collcetion'
  end

  def is_title_only?
    !self.description.present? && !self.content.present? && !self.embedded_html.present?
  end

  def is_header?
    self.mime == 'header'
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
    extraction = nil

    begin
      extraction = extract_from_diffbot(self.url)
      if extraction[:type] != 'article' && extraction[:type] != 'product' && extraction[:type] != 'image'
        extraction = extract_from_embedly(self.url)
      end
    rescue Exception => e
      puts e
      extraction = extract_from_embedly(self.url)
    end

    self.title = extraction[:title].first(255)
    self.embedded_html = extraction[:html]

    if extraction[:type] == 'html' || extraction[:type] == 'article' || extraction[:type] == 'product'
      self.mime = 'link'
    elsif extraction[:type] == 'image'
      self.mime = 'photo'
      self.thumbnail = self.url
      self.thumbnail_width = extraction[:thumbnail_width]
      self.thumbnail_height = extraction[:thumbnail_height]
    else
      self.mime = extraction[:type]
    end
    self.provider_name = extraction[:provider_name]
    self.provider_url = extraction[:provider_url]
    self.description = extraction[:description]
    self.content = extraction[:content]

    if extraction[:images]
      image = extraction[:images].first
      if image.present?
        self.thumbnail = image['url']
        # self.thumbnail_width = image['width']
        # self.thumbnail_height = image['height']
        self.thumbnail_width = image['pixel_width']
        self.thumbnail_height = image['pixel_height']
      end
    end

    if self.extractor == 'embedly' && extraction[:media] && !extraction[:media].empty?
      media = extraction[:media]
      if media.present?
        self.mime = media.type if media.type.present?
        self.embedded_html = media.html if media.html && media.html.present?
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

  def extract_from_embedly(url)
    self.extractor = 'embedly'

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
      content: extracted_obj['content']
    }
  end

  def extract_from_diffbot(url)
    self.extractor = 'diffbot'

    response = JSON.parse Net::HTTP.get("api.diffbot.com", "/v3/analyze?token=diffbotdotcomtestdrive&url=#{CGI.escape(url)}")
    obj = nil
    if response['objects']
      obj = response['objects'][0]
    end

    {
      html: obj['html'],
      title: obj['title'] || obj['label'] || url,
      url: url,
      type: obj['type']  || 'unknown',
      # provider_name: extracted_obj['provider_name'],
      # provider_url: extracted_obj['provider_url'],
      images: obj['images'],
      media: obj['videos'],
      description: obj['text'],
      thumbnail_width: obj['naturalWidth'],
      thumbnail_height: obj['naturalHeight']
      # content: extracted_obj['content'],
    }
  end

  def touch_collection
    self.collection.touch
  end
end
