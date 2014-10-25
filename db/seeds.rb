# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
courses =  Course.create([
	{name: 'Photoshop for beginners', description: 'Basic concepts of photoshoop'},
	{name: 'Illustrator for beginners', description: 'Basic concepts of illustrator'},
	{name: 'This is a very long long long long long class name', description: 'Basic concepts of illustrator'},
	{name: 'Test', description: 'Test class'}
])

user = User.create(
	name: 'Dale Ma',
	email: 'dalema22@gmail.com', 
	password: 'a1234567', 
	password_confirmation: 'a1234567', 
	courses: courses
)
