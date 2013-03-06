FactoryGirl.define do
  factory :user do
    sequence(:name)  { |n| "Name #{n}" }
    sequence(:surname)  { |n| "Surname #{n}" }
    sequence(:email) { |n| "person_#{n}@example.com" }
    password "foobar"
    password_confirmation "foobar"
    admin false
    expert false

    factory :admin do
      admin true
    end
    factory :invalid_user do
      sequence(:name)  { |n| "Name #{n}" }
      sequence(:surname)  { |n| "Surname #{n}" }
      sequence(:email) { |n| "person_#{n}@example.com" }
      password "foobar1"
      password_confirmation "foobar"

      
    end

    
  end

  
 factory :core_project,  class: Core::Project do
      sequence(:name)  { |n| "Project #{n}" }
      sequence(:short_desc)  { |n| "Short desc for #{n} project" }    
 end

factory :life_tape_post, class: LifeTape::Post do
  content "Bla bla bla"
 end

 factory :project, class: Core::Project do
  name "Bla bla bla"
 end


end