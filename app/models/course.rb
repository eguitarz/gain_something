class Course < ActiveRecord::Base
	has_many :resources, dependent: :destroy
	belongs_to :user

	paginates_per 10

  def belongs_to?(user)
    user && self.user_id == user.id
  end
end
