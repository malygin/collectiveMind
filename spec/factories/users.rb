
FactoryGirl.define do
  factory :user do
    sequence(:name) { |n| "Name #{n}" }
    sequence(:surname) { |n| "Surname #{n}" }
    sequence(:email) { |n| "person_#{n}@example.com" }
    sequence(:nickname) { |n| "Nickname #{n}" }
    password 'pascal2003'
    password_confirmation 'pascal2003'
  end

  factory :admin, parent: :user do
    admin true
  end

  factory :invalid_user, class: 'Users' do
    sequence(:name) { |n| "Name #{n}" }
    sequence(:surname) { |n| "Surname #{n}" }
    sequence(:email) { |n| "person_b#{n}@example.com" }
    password "foobar1"
    password_confirmation "foobar"
  end
end