FactoryGirl.define do
  factory :discontent, class: 'Discontent::Post' do
    sequence(:content) { |n| "what #{n}" }
    sequence(:whend) { |n| "whend #{n}" }
    sequence(:whered) { |n| "whered #{n}" }
    sequence(:what) { |n| "what #{n}" }

    status 0

    association :user, factory: :ordinary_user
    association :project, factory: :core_project

    factory :discontent_with_aspects do
      after(:create) do |post|
        aspect1 = create :aspect, project: post.project
        aspect2 = create :aspect, project: post.project
        create :discontent_post_aspect, post_id: post.id, aspect_id: aspect1.id
        create :discontent_post_aspect, post_id: post.id, aspect_id: aspect2.id
      end
    end
  end

  factory :discontent_voting, class: 'Discontent::Voting' do
    association :user, factory: :ordinary_user
    association :discontent_post, factory: :discontent
  end

  factory :discontent_union, class: 'Discontent::PostGroup' do
    status 2
  end

  factory :discontent_post_aspect, class: 'Discontent::PostAspect' do
    association :aspect, factory: :aspect
    association :post, factory: :discontent
  end

  factory :discontent_comment, class: 'Discontent::Comment' do
    sequence(:content) { |n| "discontent comment #{n}" }

    association :user, factory: :ordinary_user
    association :post, factory: :discontent
  end
end
