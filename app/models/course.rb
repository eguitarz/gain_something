class Course < ActiveRecord::Base
	has_many :resources, dependent: :destroy
	belongs_to :user
end
