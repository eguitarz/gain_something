class Collection < ActiveRecord::Base
  has_many :resources, dependent: :destroy
  belongs_to :user

  validates :name, length: { minimum: 3, maximum: 255 }, allow_blank: false
  validates :description, length: { maximum: 140 }
  paginates_per 10

  def belongs_to?(user)
    user && self.user_id == user.id
  end
end