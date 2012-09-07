# encoding: utf-8
namespace :db  do
	desc "Fill db with dample data"
	task :populate => :environment do
		#require 'faker'
		Rake::Task['db:reset'].invoke
		user1 = User.create!(:name => "Андрей",
			:surname => "Малыгин",
			:email =>"anmalygin@gmail.com",
			:password => "pascal2003",
			:password_confirmation => "pascal2003")
		#user1.toggle!(:admin)
		user2 = User.create!(:name => "Иван",
			:surname => "Дорошин",
			:email =>"anmalygin@yandex.ru",
			:password => "pascal2003",
			:password_confirmation => "pascal2003")
		admin = User.create!(:name => "Семен",
			:surname => "Админов",
			:email =>"admin@admin.com",
			:password => "admin",
			:password_confirmation => "admin")
		admin.toggle!(:admin)
		expert = User.create!(:name => "Поликарп",
			:surname => "Экспертов",
			:email =>"expert@expert.com",
			:password => "expert",
			:password_confirmation => "expert")
		expert.toggle!(:expert)

		# 99.times do |n|
		# 	name = Faker::Name.first_name
		# 	surname = Faker::Name.last_name
		# 	email = Faker::Internet.email
		# 	password = "password"
		# 	User.create!(:name => name,
		# 		:surname => surname,
		# 		:email => email,
		# 		:password => password,
		# 		:password_confirmation => password)
		# end
		# User.all(:limit => 6).each do |user|
		# 	2.times do
		# 		user.frustrations.create!(:content => Faker::Lorem.sentence(10),:structure => false)
		# 	end
		# end
	end
end