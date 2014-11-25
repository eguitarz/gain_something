class Course < ActiveRecord::Base
	has_many :resources, dependent: :destroy
	belongs_to :user

	paginates_per 10
end
