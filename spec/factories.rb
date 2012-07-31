
FactoryGirl.define do
    
    factory  :user do 
		name "Andrey Malygin"
		email "anmalygin@gmail.com"
		password "foobar"
		password_confirmation "foobar"
	end

    sequence :email do 
	   "persob-#{n}@exmaple.com"
	end

    factory :frustration  do
		content "Foo bar"
		association :user
	end

end