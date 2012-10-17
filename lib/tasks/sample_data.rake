# encoding: utf-8
namespace :db  do
	desc "Fill db with dample data"
	task :populate => :environment do
		#require 'faker'
		Rake::Task['db:reset'].invoke
		project = Project.create(:id=>1, 
			:name => "Стратегия развития ДО в СГУ на 2012-2013 год")
		test = Test.create(:id=>1, :name => "Описание собственного стиля принятия решений", :description =>"Опрос до начала процедуры принятия решений",
			:preview => "Лично Вам нижеследующие вопросы помогут разобраться, как Вы принимаете решения. Благодаря этому Вы сможете лучше понять, что именно для Вас более всего полезно в курсе по принятию решений. Ответьте, пожалуйста, на вопросы о выработке (т.е. обо всем процессе от начального уяснения проблемы до конечного выбора) Вами важных решений. Важным
			называется решение, которое в значительной мере определяет дальнейшую жизнь или
			деятельность – Вашу либо группы, коллектива, сообщества, к которому Вы принадлежите.
			Помните, пожалуйста, что ниже Вас спрашивают только о таких решениях. По каждому
			вопросу выберите тот вариант ответа, который больше всего подходит Вам. Если
			выбран «Другой ответ», то Вам следует его сформулировать. Ваши ответы не будут
			разглашены и послужат только для статистической подготовки общих выводов.")

	  quest1 = TestQuestion.create(:name => "I. Как ДО ознакомления с информацией о курсе по рациональному принятию
решений Вы считали правильным вырабатывать решения?", :type_question => 0, :order_question =>1)
		quest1.test = test
		quest1.test_answers << TestAnswer.create(:name =>"При помощи своих интуиции, опыта и здравого смысла и(или) советов авторитетных
для меня людей, так как мне не было известно о рациональной выработке решений.", :type_answer =>0)
		quest1.test_answers << TestAnswer.create(:name =>"Основываясь на своих интуиции, опыте и здравом смысл и(или) советах авторитетных
для меня людей, так как считал(а) рациональные модели и техники выработки решений не эффективными.", :type_answer =>0)
		quest1.test_answers << TestAnswer.create(:name =>"Применяя рациональные модели и техники выработки решений в отдельных особо
значимых случаях.", :type_answer =>0)
		quest1.test_answers << TestAnswer.create(:name =>"Используя рациональные модели и техники выработки решений для большинства важных проблем.", :type_answer =>0)
		quest1.test_answers << TestAnswer.create(:name =>"При помощи рациональных моделей и техник выработки решений в каждой важной проблеме", :type_answer =>0)
		quest1.test_answers << TestAnswer.create(:name =>"Другой ответ", :type_answer =>1)

			quest2 = TestQuestion.create(:name => "II-III. Представьте себе, что в том месте, где Вы работаете,
			 либо учитесь, либо
занимаетесь общественной деятельностью, коллективно вырабатывается решение по
какой-то общей для всех проблеме. И каждый может в этом участвовать или не
участвовать по своей воле. Насколько Вы были бы склонны вкладывать в выработку
решения Ваши силы и время --
<br/><br/>
II -- в случае, когда эта проблема существенно затрагивает лично Вас?", :order_question =>2, :type_question => 0)
		quest2.test = test	
		quest2.test_answers << TestAnswer.create(:name =>"Вообще не интересовался(ась) бы этим.", :type_answer =>0)
		quest2.test_answers << TestAnswer.create(:name =>"Ни в малейшей степени", :type_answer =>0)
		quest2.test_answers << TestAnswer.create(:name =>"В небольшой мере", :type_answer =>0)
		quest2.test_answers << TestAnswer.create(:name =>"В значительной степени.", :type_answer =>0)
		quest2.test_answers << TestAnswer.create(:name =>"В полной мере.", :type_answer =>0)
		quest2.test_answers << TestAnswer.create(:name =>"Другой ответ.", :type_answer =>1)
	   
	   	quest3 = TestQuestion.create(:name => "III -- в случае, когда эта проблема НЕ затрагивает существенно лично Вас?", :order_question =>3, :type_question => 0)
		quest3.test = test	
		quest3.test_answers << TestAnswer.create(:name =>"Вообще не интересовался(ась) бы этим.", :type_answer =>0)
		quest3.test_answers << TestAnswer.create(:name =>"Ни в малейшей степени", :type_answer =>0)
		quest3.test_answers << TestAnswer.create(:name =>"В небольшой мере", :type_answer =>0)
		quest3.test_answers << TestAnswer.create(:name =>"В значительной степени.", :type_answer =>0)
		quest3.test_answers << TestAnswer.create(:name =>"В полной мере.", :type_answer =>0)
		quest3.test_answers << TestAnswer.create(:name =>"Другой ответ.", :type_answer =>1)
	   
	   	quest4 = TestQuestion.create(:name => "IV-V. Предположим, что в том месте, где Вы работаете, либо учитесь, либо
занимаетесь общественной деятельностью, выработано коллективное решение по какому-то общему для всех вопросу. Сколь настойчиво Вы бы добивались
воплощения этого решения в жизнь --
<br/><br/>
IV -- в случае, когда это решение существенно затрагивает лично Вас?", :order_question =>4, :type_question => 0)
		quest4.test = test	
		quest4.test_answers << TestAnswer.create(:name =>"Вообще не интересовался(ась) бы этим.", :type_answer =>0)
		quest4.test_answers << TestAnswer.create(:name =>"Ни в малейшей степени", :type_answer =>0)
		quest4.test_answers << TestAnswer.create(:name =>"В небольшой мере", :type_answer =>0)
		quest4.test_answers << TestAnswer.create(:name =>"В значительной степени.", :type_answer =>0)
		quest4.test_answers << TestAnswer.create(:name =>"В полной мере.", :type_answer =>0)
		quest4.test_answers << TestAnswer.create(:name =>"Другой ответ.", :type_answer =>1)

 		quest5 = TestQuestion.create(:name => "V -- в случае, когда это решение НЕ затрагивает существенно лично Вас?", :order_question =>5, :type_question => 0)
		quest5.test = test

		quest5.test_answers << TestAnswer.create(:name =>"Вообще не интересовался(ась) бы этим.", :type_answer =>0)
		quest5.test_answers << TestAnswer.create(:name =>"Ни в малейшей степени", :type_answer =>0)
		quest5.test_answers << TestAnswer.create(:name =>"В небольшой мере", :type_answer =>0)
		quest5.test_answers << TestAnswer.create(:name =>"В значительной степени.", :type_answer =>0)
		quest5.test_answers << TestAnswer.create(:name =>"В полной мере.", :type_answer =>0)
		quest5.test_answers << TestAnswer.create(:name =>"Другой ответ.", :type_answer =>1)
 		
 		quest6 = TestQuestion.create(:name => "VI-VII. Представьте себе, что Вы наметили для себя очень важную цель. Избирая
путь ее достижения, в какой мере Вы считаете правильным --
<br/><br/>
VI -- руководствоваться принципом «чем быстрее, тем лучше», не размышляя,
как самый быстрый путь достижения намеченной цели повлияет на сохранение
достигнутого в долгосрочной перспективе?", :order_question =>6,:type_question => 0)
		quest6.test = test	

		quest6.test_answers << TestAnswer.create(:name =>"Вообще не ставил(а) перед собой такой вопрос.", :type_answer =>0)
		quest6.test_answers << TestAnswer.create(:name =>"Ни в малейшей степени", :type_answer =>0)
		quest6.test_answers << TestAnswer.create(:name =>"В небольшой мере", :type_answer =>0)
		quest6.test_answers << TestAnswer.create(:name =>"В значительной степени.", :type_answer =>0)
		quest6.test_answers << TestAnswer.create(:name =>"В полной мере.", :type_answer =>0)
		quest6.test_answers << TestAnswer.create(:name =>"Другой ответ.", :type_answer =>1)
 	   
 		quest7 = TestQuestion.create(:name => "VII -- пытаться прогнозировать, обеспечит ли тот или иной путь достижения
намеченной цели сохранение достигнутого в долгосрочной перспективе?", :order_question =>7,:type_question => 0)
		quest7.test = test	
		
		quest7.test_answers << TestAnswer.create(:name =>"Вообще не ставил(а) перед собой такой вопрос.", :type_answer =>0)
		quest7.test_answers << TestAnswer.create(:name =>"Ни в малейшей степени", :type_answer =>0)
		quest7.test_answers << TestAnswer.create(:name =>"В небольшой мере", :type_answer =>0)
		quest7.test_answers << TestAnswer.create(:name =>"В значительной степени.", :type_answer =>0)
		quest7.test_answers << TestAnswer.create(:name =>"В полной мере.", :type_answer =>0)
		quest7.test_answers << TestAnswer.create(:name =>"Другой ответ.", :type_answer =>1)
	 	
	 	quest8 = TestQuestion.create(:name => "VIII-IX. Если Вы оказываетесь в очень не устраивающем Вас положении, в какой
мере считаете правильным --
<br/><br/>
VIII -- поставить перед собой цель просто выйти из этого негативного положения?",:order_question =>8, :type_question => 0)
		quest8.test = test	
		quest8.test_answers << TestAnswer.create(:name =>"Вообще не размышляю на эту тему.", :type_answer =>0)
		quest8.test_answers << TestAnswer.create(:name =>"Ни в малейшей степени", :type_answer =>0)
		quest8.test_answers << TestAnswer.create(:name =>"В небольшой мере", :type_answer =>0)
		quest8.test_answers << TestAnswer.create(:name =>"В значительной степени.", :type_answer =>0)
		quest8.test_answers << TestAnswer.create(:name =>"В полной мере.", :type_answer =>0)
		quest8.test_answers << TestAnswer.create(:name =>"Другой ответ.", :type_answer =>1)
	   	
	   	quest9 = TestQuestion.create(:name => "IX -- нарисовать конкретное позитивное положение, к которому Вы хотели бы
прийти, чтобы затем выбирать путь к этой определенной цели?", :order_question =>9, :type_question => 0)
		quest9.test = test	
		quest9.test_answers << TestAnswer.create(:name =>"Вообще не размышляю на эту тему.", :type_answer =>0)
		quest9.test_answers << TestAnswer.create(:name =>"Ни в малейшей степени", :type_answer =>0)
		quest9.test_answers << TestAnswer.create(:name =>"В небольшой мере", :type_answer =>0)
		quest9.test_answers << TestAnswer.create(:name =>"В значительной степени.", :type_answer =>0)
		quest9.test_answers << TestAnswer.create(:name =>"В полной мере.", :type_answer =>0)
		quest9.test_answers << TestAnswer.create(:name =>"Другой ответ.", :type_answer =>1)
	   	
	   	quest10 = TestQuestion.create(:name => "X-XI. Если Вы занимаетесь детальным формулированием важной цели, подробно
вырисовывая образ желаемого будущего (т.е. цель), в какой мере считаете
правильным --
<br/><br/>
X -- рисовать только то позитивное, чего Вы желаете достичь в будущем?", :order_question =>10,:type_question => 0)
		quest10.test = test	

		quest10.test_answers << TestAnswer.create(:name =>"ВВообще не размышляю на эту тему.", :type_answer =>0)
		quest10.test_answers << TestAnswer.create(:name =>"Ни в малейшей степени", :type_answer =>0)
		quest10.test_answers << TestAnswer.create(:name =>"В небольшой мере", :type_answer =>0)
		quest10.test_answers << TestAnswer.create(:name =>"В значительной степени.", :type_answer =>0)
		quest10.test_answers << TestAnswer.create(:name =>"В полной мере.", :type_answer =>0)
		quest10.test_answers << TestAnswer.create(:name =>"Другой ответ.", :type_answer =>1)

	   	
	   	quest11 = TestQuestion.create(:name => "XI -- уделять много внимания еще и обрисовыванию того возможного негативного,
чего Вы желали бы избежать в будущем?", :order_question =>11, :type_question => 0)
		quest11.test = test	

		quest11.test_answers << TestAnswer.create(:name =>"Вообще не размышляю на эту тему.", :type_answer =>0)
		quest11.test_answers << TestAnswer.create(:name =>"Ни в малейшей степени", :type_answer =>0)
		quest11.test_answers << TestAnswer.create(:name =>"В небольшой мере", :type_answer =>0)
		quest11.test_answers << TestAnswer.create(:name =>"В значительной степени.", :type_answer =>0)
		quest11.test_answers << TestAnswer.create(:name =>"В полной мере.", :type_answer =>0)
		quest11.test_answers << TestAnswer.create(:name =>"Другой ответ.", :type_answer =>1)
	   	
	   	quest12 = TestQuestion.create(:name => "XII. Когда Вы планируете, какими методами и средствами будете разрешать
важные задачи, которые стоят перед Вами, в какой степени считаете правильным
анализировать то негативное, что может произойти на пути разрешения этих задач,
а также другие возможные препятствия на нем, чтобы заранее принять меры для
преодоления этого?",:order_question =>12, :type_question => 0)
		quest12.test = test	
        quest12.test_answers << TestAnswer.create(:name =>"Вообще не размышляю на эту тему.", :type_answer =>0)
		quest12.test_answers << TestAnswer.create(:name =>"Ни в малейшей степени", :type_answer =>0)
		quest12.test_answers << TestAnswer.create(:name =>"В небольшой мере", :type_answer =>0)
		quest12.test_answers << TestAnswer.create(:name =>"В значительной степени.", :type_answer =>0)
		quest12.test_answers << TestAnswer.create(:name =>"В полной мере.", :type_answer =>0)
		quest12.test_answers << TestAnswer.create(:name =>"Другой ответ.", :type_answer =>1)

	   	quest13 = TestQuestion.create(:name => "XIII-XIV. Если Вы ищете решение важной проблемы, в какой мере считаете
правильным --
<br/><br/>
XIII -- останавливаться на первом же оказавшемся у Вас в распоряжении
удовлетворительном варианте решения, чтобы не «тратить» время, силы и средства
на поиски и изучение других возможных вариантов?",:order_question =>13, :type_question => 0)
		quest13.test = test	
        quest13.test_answers << TestAnswer.create(:name =>"Вообще не размышляю на эту тему.", :type_answer =>0)
		quest13.test_answers << TestAnswer.create(:name =>"Ни в малейшей степени", :type_answer =>0)
		quest13.test_answers << TestAnswer.create(:name =>"В небольшой мере", :type_answer =>0)
		quest13.test_answers << TestAnswer.create(:name =>"В значительной степени.", :type_answer =>0)
		quest13.test_answers << TestAnswer.create(:name =>"В полной мере.", :type_answer =>0)
		quest13.test_answers << TestAnswer.create(:name =>"Другой ответ.", :type_answer =>1)

	   	quest14 = TestQuestion.create(:name => "XIV -- набирать множество разных резонных вариантов решения, чтобы потом
сравнить их и выбрать лучший?",:order_question =>14, :type_question => 0)
		quest14.test = test	
        quest14.test_answers << TestAnswer.create(:name =>"Вообще не размышляю на эту тему.", :type_answer =>0)
		quest14.test_answers << TestAnswer.create(:name =>"Ни в малейшей степени", :type_answer =>0)
		quest14.test_answers << TestAnswer.create(:name =>"В небольшой мере", :type_answer =>0)
		quest14.test_answers << TestAnswer.create(:name =>"В значительной степени.", :type_answer =>0)
		quest14.test_answers << TestAnswer.create(:name =>"В полной мере.", :type_answer =>0)
		quest14.test_answers << TestAnswer.create(:name =>"Другой ответ.", :type_answer =>1)

	   	quest15 = TestQuestion.create(:name => "XV-XVI. Представьте себе, что в том месте, где Вы работаете, либо учитесь, либо
занимаетесь общественной деятельностью, коллективно вырабатывается решение по
какому-то общему для всех вопросу. И в коллективе есть разные отношения к этому
вопросу. Участвуя в выработке решения, считаете ли Вы правильным НЕ «тратить»
время и силы на освоение других взглядов и согласование позиций?
<br/><br/>
XV -- в случае, когда это решение существенно затрагивает лично Вас?",:order_question =>15, :type_question => 0)
		quest15.test = test	
        quest15.test_answers << TestAnswer.create(:name =>"Вообще не интересовался(ась) бы этим.", :type_answer =>0)
		quest15.test_answers << TestAnswer.create(:name =>"Ни в малейшей степени", :type_answer =>0)
		quest15.test_answers << TestAnswer.create(:name =>"В небольшой мере", :type_answer =>0)
		quest15.test_answers << TestAnswer.create(:name =>"В значительной степени.", :type_answer =>0)
		quest15.test_answers << TestAnswer.create(:name =>"В полной мере.", :type_answer =>0)
		quest15.test_answers << TestAnswer.create(:name =>"Другой ответ.", :type_answer =>1)

	   	quest16 = TestQuestion.create(:name => "XVI -- в случае, когда это решение НЕ затрагивает существенно лично Вас?",:order_question =>16, :type_question => 0)
		quest16.test = test	
        quest16.test_answers << TestAnswer.create(:name =>"Вообще не интересовался(ась) бы этим.", :type_answer =>0)
		quest16.test_answers << TestAnswer.create(:name =>"Ни в малейшей степени", :type_answer =>0)
		quest16.test_answers << TestAnswer.create(:name =>"В небольшой мере", :type_answer =>0)
		quest16.test_answers << TestAnswer.create(:name =>"В значительной степени.", :type_answer =>0)
		quest16.test_answers << TestAnswer.create(:name =>"В полной мере.", :type_answer =>0)
		quest16.test_answers << TestAnswer.create(:name =>"Другой ответ.", :type_answer =>1)


	   	quest17 = TestQuestion.create(:name => "XVII. Участвуя в выработке решения, считаете ли Вы правильным НЕ «тратить»
время и силы на попытки анализировать процесс выработки решения и свои
действия в нем как бы со стороны?",:order_question =>17, :type_question => 0)
		quest17.test = test	
        quest17.test_answers << TestAnswer.create(:name =>"Вообще не размышляю на эту тему", :type_answer =>0)
		quest17.test_answers << TestAnswer.create(:name =>"Да, так как это отвлекает от самой выработки решения.", :type_answer =>0)
		quest17.test_answers << TestAnswer.create(:name =>"Да, так как мне не известны эффективные методы оценки процесса выработки решения
и своих действий в нем как бы со стороны.", :type_answer =>0)
		quest17.test_answers << TestAnswer.create(:name =>"Нет, я бы предпочел(ла) время от времени анализировать процесс выработки решения и
свои действия в нем как бы со стороны, однако не знаю, как это эффективно делать..", :type_answer =>0)
		quest17.test_answers << TestAnswer.create(:name =>"Нет, я бы использовал(а) для этого известные мне рациональные методы.", :type_answer =>0)
		quest17.test_answers << TestAnswer.create(:name =>"Другой ответ.", :type_answer =>1)

	   	quest18 = TestQuestion.create(:name => "XVIII. В какой мере Вас интересует вопрос благополучия Института Открытого
Образования?",:order_question =>18, :type_question => 0)
		quest18.test = test	
        quest18.test_answers << TestAnswer.create(:name =>"Вообще не ставил(а) перед собой такой вопрос.", :type_answer =>0)
		quest18.test_answers << TestAnswer.create(:name =>"Ни в малейшей степени", :type_answer =>0)
		quest18.test_answers << TestAnswer.create(:name =>"В небольшой мере", :type_answer =>0)
		quest18.test_answers << TestAnswer.create(:name =>"В значительной степени.", :type_answer =>0)
		quest18.test_answers << TestAnswer.create(:name =>"В полной мере.", :type_answer =>0)
		quest18.test_answers << TestAnswer.create(:name =>"Другой ответ.", :type_answer =>1)

	   	quest19 = TestQuestion.create(:name => "XIX. С кем из ближайшего окружения Вы чаще всего обсуждаете волнующие Вас
проблемы? ",:order_question =>19, :type_question => 0)
		quest19.test = test	
        quest19.test_answers << TestAnswer.create(:name =>"С членами семьи, родственниками.", :type_answer =>0)
		quest19.test_answers << TestAnswer.create(:name =>"С товарищами по работе (учебе)", :type_answer =>0)
		quest19.test_answers << TestAnswer.create(:name =>"С друзьями вне работы", :type_answer =>0)
		quest19.test_answers << TestAnswer.create(:name =>"С соседями, знакомыми", :type_answer =>0)
		quest19.test_answers << TestAnswer.create(:name =>"С единомышленниками в разного рода организациях (политических,
общественных)", :type_answer =>0)
		quest19.test_answers << TestAnswer.create(:name =>"В Интернете", :type_answer =>0)
		quest19.test_answers << TestAnswer.create(:name =>"Ни с кем не обсуждаю", :type_answer =>0)
		quest19.test_answers << TestAnswer.create(:name =>"Затрудняюсь ответить", :type_answer =>0)
		quest19.test_answers << TestAnswer.create(:name =>"Другой ответ.", :type_answer =>1)
	  
	   	quest20 = TestQuestion.create(:name => "XX. Есть ли у Вас предшествующий опыт участия в коллективном принятии
решений относительно модернизации работы каких-либо учреждений,
организаций или служб?",:order_question =>20, :type_question => 0)
		quest20.test = test	
        quest20.test_answers << TestAnswer.create(:name =>"Вообще не ставил(а) перед собой такой вопрос.", :type_answer =>0)
		quest20.test_answers << TestAnswer.create(:name =>"Ни в малейшей степени", :type_answer =>0)
		quest20.test_answers << TestAnswer.create(:name =>"В небольшой мере", :type_answer =>0)
		quest20.test_answers << TestAnswer.create(:name =>"В значительной степени.", :type_answer =>0)
		quest20.test_answers << TestAnswer.create(:name =>"В полной мере.", :type_answer =>0)
		quest20.test_answers << TestAnswer.create(:name =>"Другой ответ.", :type_answer =>1)

	   	quest21 = TestQuestion.create(:name => "XXI. Есть ли у Вас желание лично принять участие в разработке проекта модернизации Института Открытого Образования?",
	   		:order_question =>21, :type_question => 0)
		quest21.test = test	
        quest21.test_answers << TestAnswer.create(:name =>"Вообще не ставил(а) перед собой такой вопрос.", :type_answer =>0)
		quest21.test_answers << TestAnswer.create(:name =>"Ни в малейшей степени", :type_answer =>0)
		quest21.test_answers << TestAnswer.create(:name =>"В небольшой мере", :type_answer =>0)
		quest21.test_answers << TestAnswer.create(:name =>"В значительной степени.", :type_answer =>0)
		quest21.test_answers << TestAnswer.create(:name =>"В полной мере.", :type_answer =>0)
		quest21.test_answers << TestAnswer.create(:name =>"Другой ответ.", :type_answer =>1)
			
		quest21.save!
		quest20.save!
		quest19.save!
		quest18.save!
		quest17.save!
		quest16.save!
		quest15.save!
		quest14.save!
		quest13.save!
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
			:login => "pisynka",
			:password => "pascal2003",
			:password_confirmation => "pascal2003")
		
		admin = User.create!(:name => "Олег",
			:surname => "Савельзон",
			:email =>"pprsgu@gmail.com",
			:password => "admin",
			:password_confirmation => "admin")
		admin.toggle!(:admin)

		admin2 = User.create!(:name => "Илья",
			:surname => "Шугурин",
			:email =>"ilbazer@gmail.com",
			:password => "mass45",
			:password_confirmation => "mass45")
		admin2.toggle!(:admin)

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