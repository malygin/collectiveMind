
FactoryGirl.define do
  factory :life_tape_post, :class => 'LifeTape::Post'  do
    content  "life tape post for project"
    sequence(:number_views) { |n| n*10 }

  end


end