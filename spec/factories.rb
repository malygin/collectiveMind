FactoryGirl.define do
  factory :user do
    sequence(:name)  { |n| "Name #{n}" }
    sequence(:surname)  { |n| "Surname #{n}" }
    sequence(:email) { |n| "person_#{n}@example.com" }
    password "foobar"
    password_confirmation "foobar"

    factory :admin do
      admin true
    end
  end


end