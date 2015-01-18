FactoryGirl.define do
  factory :life_tape_post, class: 'LifeTape::Post' do
    sequence(:content) { |n| "life tape post #{n}" }
    sequence(:number_views) { |n| n * 10 }

    association :user, factory: :ordinary_user
    association :project, factory: :core_project

    after(:create) do |post|
      post.aspect = create :aspect, project: post.project
      post.save
      create :discontent_aspects_life_tape_posts, discontent_aspect: post.aspect, life_tape_post: post
    end
  end

  factory :life_tape_comment, class: 'LifeTape::Comment' do
    sequence(:content) { |n| "life tape comment #{n}" }

    association :user, factory: :ordinary_user
  end
end
