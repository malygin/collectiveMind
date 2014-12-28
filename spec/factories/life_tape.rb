FactoryGirl.define do
  factory :discontent_aspect, class: 'Discontent::Aspect' do
    sequence(:content) { |n| "aspect #{n}" }
  end

  factory :life_tape_post, class: 'LifeTape::Post' do
    content 'life tape post for project'
    sequence(:number_views) { |n| n*10 }
  end

  factory :life_tape_comment, class: 'LifeTape::Comment' do
    content 'life tape comment for post'
  end
end
