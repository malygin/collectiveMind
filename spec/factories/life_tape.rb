FactoryGirl.define do
  factory :life_tape_post, class: 'LifeTape::Post' do
    content 'life tape post for project'
    sequence(:number_views) { |n| n*10 }

    association :aspect

    after(:create) do |post|
      create :discontent_aspects_life_tape_posts, discontent_aspect: post.aspect, life_tape_post: post
    end
  end

  factory :life_tape_comment, class: 'LifeTape::Comment' do
    content 'life tape comment for post'
  end
end
