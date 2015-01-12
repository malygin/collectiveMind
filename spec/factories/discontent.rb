FactoryGirl.define do
  factory :aspect, class: 'Discontent::Aspect' do
    sequence(:content) { |n| "aspect #{n}" }
  end

  factory :discontent, class: 'Discontent::Post' do
    sequence(:content) { |n| "what #{n}" }
    sequence(:whend) { |n| "whend #{n}" }
    sequence(:whered) { |n| "whered #{n}" }
  end

  factory :discontent_union, class: 'Discontent::Post' do
    status 2
  end

  factory :discontent_post_aspect, class: 'Discontent::PostAspect' do
  end

  factory :discontent_comment, class: 'Discontent::Comment' do
    content 'discontent comment for post'
  end

  factory :discontent_aspects_life_tape_posts, class: 'Discontent::AspectsLifeTapePost' do
  end
end
