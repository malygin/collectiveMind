# encoding: utf-8
namespace :db  do
	desc "Fill db with dample data"
	task :populate => :environment do
		#require 'faker'
		Rake::Task['db:reset'].invoke
		project = Project.create(:id=>1, 
			:name => "Стратегия развития ДО в СГУ на 2012-2013 год")
		test = Test.create(:id=>1, :name => "Начальный тест", :description =>"социологический тест")
	  quest2 = TestQuestion.create(:name => "I. Как до ознакомления с информацией о курсе по рациональному принятию
решений Вы считали правильным принимать важные решения?", :type_question => 0, :order_question =>1)
		quest2.test = test
		quest2.test_answers << TestAnswer.create(:name =>"При помощи своих интуиции, опыта и здравого смысла и(или) советов авторитетных для меня людей, так как мне не было известно о рациональном принятия решений.", :type_answer =>0)
		quest2.test_answers << TestAnswer.create(:name =>"Основываясь на своих интуиции, опыте и здравом смысл и(или) советах авторитетных для меня людей, так как считал(а) рациональные модели и техники принятия решений не эффективными.", :type_answer =>0)
		quest2.test_answers << TestAnswer.create(:name =>"Применяя рациональные модели и техники принятия решений в отдельных особо значимых случаях.", :type_answer =>0)
		quest2.test_answers << TestAnswer.create(:name =>"Используя рациональные модели и техники принятия решений для большинства важных проблем.", :type_answer =>0)
		quest2.test_answers << TestAnswer.create(:name =>"При помощи рациональных моделей и техник принятия решений в каждой важной", :type_answer =>0)
		
			quest1 = TestQuestion.create(:name => "II. Представьте себе, что в том месте, где Вы работаете, либо учитесь, либо
занимаетесь общественной деятельностью, коллективно принимается решение по
какому-то общему для всех вопросу. И каждый может в этом участвовать или не
участвовать по своей воле. Насколько Вы были бы склонны вкладывать в принятие
решения Ваши силы и время?", :order_question =>2, :type_question => 0)
		quest1.test = test	
		quest1.test_answers << TestAnswer.create(:name =>"Ни в малейшей степени", :type_answer =>0)
		quest1.test_answers << TestAnswer.create(:name =>"В небольшой мере", :type_answer =>0)
		quest1.test_answers << TestAnswer.create(:name =>"Отчасти.", :type_answer =>0)
		quest1.test_answers << TestAnswer.create(:name =>"В значительной степени.", :type_answer =>0)
		quest1.test_answers << TestAnswer.create(:name =>"В полной мере.", :type_answer =>0)
	   
	   	quest3 = TestQuestion.create(:name => "III. Предположим, что в том месте, где Вы работаете, либо учитесь, либо занимаетесь
общественной деятельностью, принято коллективное решение по какому-то общему
для всех вопросу. Сколь настойчиво Вы бы добивались воплощения этого решения в
жизнь?", :order_question =>3, :type_question => 0)
		quest3.test = test	
		quest3.test_answers << TestAnswer.create(:name =>"Вообще не добивался(ась) бы.", :type_answer =>0)
		quest3.test_answers << TestAnswer.create(:name =>"Мог(ла) бы что-то сделать в поддержку, если это не потребовало бы сил и времени.", :type_answer =>0)
		quest3.test_answers << TestAnswer.create(:name =>"Потратил(а) бы немного сил и времени.", :type_answer =>0)
		quest3.test_answers << TestAnswer.create(:name =>"Приложил(а) бы большие усилия.", :type_answer =>0)
		quest3.test_answers << TestAnswer.create(:name =>"Стал(а) бы настойчиво добиваться этого до тех пор, пока решение не было бы воплощено в жизнь.", :type_answer =>0)
	   
	   	quest4 = TestQuestion.create(:name => "IV. Когда Вы определили для себя очень важную цель, в какой мере считаете
правильным  стремиться достичь ее как можно быстрее и полнее, не тратя времени на
то, чтобы пытаться спрогнозировать, не повредит ли эта быстрота и полнота
поддержанию целевого положения в дальнейшем?", :order_question =>4, :type_question => 0)
		quest4.test = test	
		quest4.test_answers << TestAnswer.create(:name =>"Ни в малейшей степени.", :type_answer =>0)
		quest4.test_answers << TestAnswer.create(:name =>"В небольшой мере.", :type_answer =>0)
		quest4.test_answers << TestAnswer.create(:name =>"Отчасти.", :type_answer =>0)
		quest4.test_answers << TestAnswer.create(:name =>"В значительной степени.", :type_answer =>0)
		quest4.test_answers << TestAnswer.create(:name =>"В полной мере.", :type_answer =>0)
 		
 		quest5 = TestQuestion.create(:name => "V. Решая, как достичь данную цель, пытаться прогнозировать, обеспечит ли тот
или иной путь ее достижения прочное целевое положение в дальнейшем?", :order_question =>5, :type_question => 0)
		quest5.test = test	
		quest5.test_answers << TestAnswer.create(:name =>"Ни в малейшей степени.", :type_answer =>0)
		quest5.test_answers << TestAnswer.create(:name =>"В небольшой мере.", :type_answer =>0)
		quest5.test_answers << TestAnswer.create(:name =>"Отчасти.", :type_answer =>0)
		quest5.test_answers << TestAnswer.create(:name =>"В значительной степени.", :type_answer =>0)
		quest5.test_answers << TestAnswer.create(:name =>"В полной мере.", :type_answer =>0)
 		
 		quest6 = TestQuestion.create(:name => "VI. Если Вы оказываетесь в очень не устраивающем Вас положении, в какой мере
считаете правильным поставить перед собой цель просто выйти из этого негативного положения?", :order_question =>6,:type_question => 0)
		quest6.test = test	
		quest6.test_answers << TestAnswer.create(:name =>"Ни в малейшей степени.", :type_answer =>0)
		quest6.test_answers << TestAnswer.create(:name =>"В небольшой мере.", :type_answer =>0)
		quest6.test_answers << TestAnswer.create(:name =>"Отчасти.", :type_answer =>0)
		quest6.test_answers << TestAnswer.create(:name =>"В значительной степени.", :type_answer =>0)
		quest6.test_answers << TestAnswer.create(:name =>"В полной мере.", :type_answer =>0)
	   
 		quest7 = TestQuestion.create(:name => "VII. Если Вы оказываетесь в очень не устраивающем Вас положении, в какой мере
считаете правильным нарисовать конкретное позитивное положение, к которому Вы хотели бы
прийти, чтобы затем выбирать путь к этой определенной цели?", :order_question =>7,:type_question => 0)
		quest7.test = test	
		quest7.test_answers << TestAnswer.create(:name =>"Ни в малейшей степени.", :type_answer =>0)
		quest7.test_answers << TestAnswer.create(:name =>"В небольшой мере.", :type_answer =>0)
		quest7.test_answers << TestAnswer.create(:name =>"Отчасти.", :type_answer =>0)
		quest7.test_answers << TestAnswer.create(:name =>"В значительной степени.", :type_answer =>0)
		quest7.test_answers << TestAnswer.create(:name =>"В полной мере.", :type_answer =>0)
	 	
	 	quest8 = TestQuestion.create(:name => "VIII. Если Вы занимаетесь детальным формулированием важной цели, подробно
вырисовывая образ желаемого будущего (т.е. в цель), в какой мере считаете
правильным рисовать только то позитивное, чего Вы желаете достичь в будущем?",:order_question =>8, :type_question => 0)
		quest8.test = test	
		quest8.test_answers << TestAnswer.create(:name =>"Я не формулирую таким образом важные цели.", :type_answer =>0)
		quest8.test_answers << TestAnswer.create(:name =>"Ни в малейшей степени.", :type_answer =>0)
		quest8.test_answers << TestAnswer.create(:name =>"В небольшой мере.", :type_answer =>0)
		quest8.test_answers << TestAnswer.create(:name =>"Отчасти.", :type_answer =>0)
		quest8.test_answers << TestAnswer.create(:name =>"В значительной степени.", :type_answer =>0)
		quest8.test_answers << TestAnswer.create(:name =>"В полной мере.", :type_answer =>0)
	   	
	   	quest9 = TestQuestion.create(:name => "IX. Если Вы занимаетесь детальным формулированием важной цели, подробно
вырисовывая образ желаемого будущего (т.е. в цель), в какой мере считаете
правильным уделять много внимания еще и обрисовыванию того возможного негативного,
чего Вы желали бы избежать в будущем?", :order_question =>9, :type_question => 0)
		quest9.test = test	
		quest9.test_answers << TestAnswer.create(:name =>"Я не формулирую таким образом важные цели.", :type_answer =>0)
		quest9.test_answers << TestAnswer.create(:name =>"Ни в малейшей степени.", :type_answer =>0)
		quest9.test_answers << TestAnswer.create(:name =>"В небольшой мере.", :type_answer =>0)
		quest9.test_answers << TestAnswer.create(:name =>"Отчасти.", :type_answer =>0)
		quest9.test_answers << TestAnswer.create(:name =>"В значительной степени.", :type_answer =>0)
		quest9.test_answers << TestAnswer.create(:name =>"В полной мере.", :type_answer =>0)
	   	
	   	quest10 = TestQuestion.create(:name => "X. Когда Вы планируете, какими методами и средствами будете разрешать
важные задачи, которые стоят перед Вами, в какой степени считаете правильным
анализировать то негативное, что может произойти на пути разрешения этих задач,
а также другие возможные препятствия на нем, чтобы заранее принять меры для преодоления этого?", :order_question =>10,:type_question => 0)
		quest10.test = test	
		quest10.test_answers << TestAnswer.create(:name =>"Я не планирую таким образом разрешение важных задач.", :type_answer =>0)
		quest10.test_answers << TestAnswer.create(:name =>"Ни в малейшей степени.", :type_answer =>0)
		quest10.test_answers << TestAnswer.create(:name =>"В небольшой мере.", :type_answer =>0)
		quest10.test_answers << TestAnswer.create(:name =>"Отчасти.", :type_answer =>0)
		quest10.test_answers << TestAnswer.create(:name =>"В значительной степени.", :type_answer =>0)
		quest10.test_answers << TestAnswer.create(:name =>"В полной мере.", :type_answer =>0)
	   	
	   	quest11 = TestQuestion.create(:name => "XI. Если Вы ищете решение важной проблемы, в какой мере считаете
правильным  останавливаться на первом же оказавшемся у Вас в распоряжении удовлетворительном варианте
решения, чтобы не «тратить» время, силы и средства на поиски и изучение других
возможных вариантов?", :order_question =>11, :type_question => 0)
		quest11.test = test	
		quest11.test_answers << TestAnswer.create(:name =>"Ни в малейшей степени.", :type_answer =>0)
		quest11.test_answers << TestAnswer.create(:name =>"В небольшой мере.", :type_answer =>0)
		quest11.test_answers << TestAnswer.create(:name =>"Отчасти.", :type_answer =>0)
		quest11.test_answers << TestAnswer.create(:name =>"В значительной степени.", :type_answer =>0)
		quest11.test_answers << TestAnswer.create(:name =>"В полной мере.", :type_answer =>0)
	   	
	   	quest12 = TestQuestion.create(:name => "XII. Если Вы ищете решение важной проблемы, в какой мере считаете
правильным  набирать множество разных резонных вариантов решения, чтобы потом
сравнить их и выбрать лучший?",:order_question =>12, :type_question => 0)
		quest12.test = test	
		quest12.test_answers << TestAnswer.create(:name =>"Ни в малейшей степени.", :type_answer =>0)
		quest12.test_answers << TestAnswer.create(:name =>"В небольшой мере.", :type_answer =>0)
		quest12.test_answers << TestAnswer.create(:name =>"Отчасти.", :type_answer =>0)
		quest12.test_answers << TestAnswer.create(:name =>"В значительной степени.", :type_answer =>0)
		quest12.test_answers << TestAnswer.create(:name =>"В полной мере.", :type_answer =>0)

		quest12.save!
		quest11.save!
		quest10.save!
		quest9.save!
		quest8.save!
		quest7.save!
		quest6.save!
		quest5.save!
		quest4.save!
		quest3.save!
		quest1.save!
		quest2.save!


		user1 = User.create!(:name => "Андрей",
			:surname => "Малыгин",
			:email =>"anmalygin@gmail.com",
			:login => "malyginav",
			:password => "pascal2003",
			:password_confirmation => "pascal2003")
		#user1.toggle!(:admin)
		user2 = User.create!(:name => "Иван",
			:surname => "Дорошин",
			:email =>"anmalygin@yandex.ru",
			:password => "pascal2003",
			:password_confirmation => "pascal2003")
		admin = User.create!(:name => "Олег",
			:surname => "Савельзон",
			:email =>"pprsgu@gmail.com",
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