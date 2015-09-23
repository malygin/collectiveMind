FactoryGirl.define do
  factory :user do
    sequence(:name) { |n| "Name #{n}" }
    sequence(:surname) { |n| "Surname #{n}" }
    sequence(:email) { |n| "person_#{n}@example.com" }
    sequence(:nickname) { |n| "Nickname #{n}" }
    password 'pascal2003'
    password_confirmation 'pascal2003'
    type_user 0
  end

  factory :moderator, parent: :user do
    type_user 1
  end

  factory :ordinary_user, parent: :user do
    type_user 0
  end

  factory :invalid_user, class: 'Users' do
    sequence(:name) { |n| "Name #{n}" }
    sequence(:surname) { |n| "Surname #{n}" }
    sequence(:email) { |n| "person_b#{n}@example.com" }
    password 'foobar1'
    password_confirmation 'foobar'
  end

  factory :user_check, class: 'UserCheck' do
    status true
    association :user, factory: :ordinary_user
    association :project, factory: :core_project
  end
end
