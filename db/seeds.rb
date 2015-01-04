# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

collections = 15.times.map do |i| 
	Collection.create(
		{ name: Forgery(:lorem_ipsum).title(random: true), description: Forgery('lorem_ipsum').paragraphs(3, random: true), user_id: 1 }
	)
end

user = User.first || User.create(
  name: 'Dale Ma',
  email: 'dalema22@gmail.com', 
  password: 'a1234567', 
  password_confirmation: 'a1234567'
)

user.collections << collections
user.save
