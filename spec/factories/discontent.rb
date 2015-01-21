FactoryGirl.define do
  factory :aspect, class: 'Discontent::Aspect' do
    sequence(:content) { |n| "aspect #{n}" }
  end

  factory :discontent, class: 'Discontent::Post' do
    sequence(:content) { |n| "what #{n}" }
    sequence(:whend) { |n| "whend #{n}" }
    sequence(:whered) { |n| "whered #{n}" }

    status 0

    association :user, factory: :ordinary_user
    association :project, factory: :core_project

    after(:create) do |post|
      aspect1 = create :aspect, project: post.project
      aspect2 = create :aspect, project: post.project
      create :discontent_post_aspect, post_id: post.id, aspect_id: aspect1.id
      create :discontent_post_aspect, post_id: post.id, aspect_id: aspect2.id
    end
  end

  factory :discontent_union, class: 'Discontent::Post' do
    status 2
  end

  factory :discontent_post_aspect, class: 'Discontent::PostAspect' do
  end

  factory :discontent_comment, class: 'Discontent::Comment' do
    sequence(:content) { |n| "discontent comment #{n}" }
  end

  factory :discontent_aspects_life_tape_posts, class: 'Discontent::AspectsLifeTapePost' do
  end
end
