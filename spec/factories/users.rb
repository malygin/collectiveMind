
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
    type_user 1
  end

  factory :expert, parent: :user do
    type_user 2
  end
  factory :jury, parent: :user do
    type_user 3
  end
  factory :rc_club, parent: :user do
    type_user 4
  end


  factory :invalid_user, class: 'Users' do
    sequence(:name) { |n| "Name #{n}" }
    sequence(:surname) { |n| "Surname #{n}" }
    sequence(:email) { |n| "person_b#{n}@example.com" }
    password "foobar1"
    password_confirmation "foobar"
  end
end