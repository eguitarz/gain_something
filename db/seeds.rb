# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
User.create(email: 'dalema22@gmail.com', password: 'a1234567', :password_confirmation => 'a1234567')
Course.create(name: 'Photoshop for beginners', description: 'Basic concepts of photoshoop')