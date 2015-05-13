FactoryGirl.define do
  factory :user do
    sequence(:name) { |n| "Name #{n}" }
    sequence(:surname) { |n| "Surname #{n}" }
    sequence(:email) { |n| "person_#{n}@example.com" }
    sequence(:nickname) { |n| "Nickname #{n}" }
    password 'pascal2003'
    password_confirmation 'pascal2003'
    type_user nil
  end

  factory :prime_admin, parent: :user do
    type_user 1
  end

  factory :moderator, parent: :user do
    type_user 6
  end

  factory :expert, parent: :user do
    role_stat 2
  end

  factory :jury, parent: :user do
    type_user 3
  end

  factory :club_user, parent: :user do
    type_user 4
  end

  factory :club_watcher, parent: :user do
    type_user 5
  end

  factory :ordinary_user, parent: :user do
    type_user 8
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
