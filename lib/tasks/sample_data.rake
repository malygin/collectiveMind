# encoding: utf-8
namespace :db  do
	desc "Fill db with dample data"
	task :populate => :environment do
		#require 'faker'
		Rake::Task['db:reset'].invoke
		project = Core::Project.create(:id=>2, 
			:name => "Стратегия развития ДО в СГУ на 2012-2013 год")

		Discontent::Aspect.create!(content: 'Социальные ', project:  project)
		Discontent::Aspect.create!(content: 'Технологические', project:  project)
		Discontent::Aspect.create!(content: 'Брендинг', project:  project)
		Discontent::Aspect.create!(content: 'Учеба', project:  project)
		Discontent::Aspect.create!(content: 'Новые профессии', project:  project)
		Discontent::Aspect.create!(content: 'Создание профессионалов', project:  project)
  		user1 = User.create!(:name => "Сергей",
			:surname => "Кириллов",
			:email =>"admin@mass-descion.ru",
			:login => "admin",
			:password => "adminpassword",
			:password_confirmation => "adminpassword",
      :type_user=> 1)

		


		30.times do |n|
			name = Faker::Name.first_name
			surname = Faker::Name.last_name
			email = Faker::Internet.email
			password = "password"
			User.create!(:name => name,
				:surname => surname,
				:email => email,
				:password => password,
				:password_confirmation => password)
		end
		User.all(:limit => 13).each do |user|
			3.times do
        d =Discontent::Aspect.order("RANDOM()").first
				l = LifeTape::Post.create!(:content => Faker::Lorem.sentence(30), :project => project, :user => user )
			  l.discontent_aspects << d
        l.save!
      end
		end
	end
end