class Collection < ActiveRecord::Base
  has_many :resources, dependent: :destroy
  belongs_to :user

  validates :name, length: { minimum: 2, maximum: 200 }, allow_blank: false
  validates :description, length: { maximum: 140 }
  paginates_per 10

  attr_accessor :is_visible

  def belongs_to?(user)
    user && self.user_id == user.id
  end
end