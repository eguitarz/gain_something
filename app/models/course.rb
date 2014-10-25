class Course < ActiveRecord::Base
	has_many :resources
	belongs_to :user
end
