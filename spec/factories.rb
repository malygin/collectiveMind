FactoryGirl.define do
  factory :user do
    sequence(:name)  { |n| "Name #{n}" }
    sequence(:surname)  { |n| "Surname #{n}" }
    sequence(:email) { |n| "person_#{n}@example.com" }
    password "foobar123"
    password_confirmation "foobar123"
    admin false
    expert false

    factory :admin do
      admin true
    end
    factory :invalid_user do
      sequence(:name)  { |n| "Name #{n}" }
      sequence(:surname)  { |n| "Surname #{n}" }
      sequence(:email) { |n| "person_b#{n}@example.com" }
      password "foobar1"
      password_confirmation "foobar"      
    end    
  end


  factory :aspect, class: Discontent::Aspect do
    sequence(:content) {|n| "Aspect #{n}"}
    sequence(:position) {|n| "#{n}"}
  end

  factory :life_tape_post, class: LifeTape::Post do
    content "Bla bla bla"
  end

  factory :project, class: Core::Project do
    name "Bla bla bla"
  end


end