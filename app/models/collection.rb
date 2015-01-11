class Collection < ActiveRecord::Base
  has_many :resources, dependent: :destroy
  belongs_to :user

  validates :name, length: { minimum: 2, maximum: 200 }, allow_blank: false
  validates :description, length: { maximum: 140 }
  paginates_per 10

  scope :visible, -> { where(is_visible: true) }

  def belongs_to?(user)
    user && self.user_id == user.id
  end
end