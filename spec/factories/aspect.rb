FactoryGirl.define do
  # factory :collect_info_post, class: 'CollectInfo::Post' do
  #   sequence(:content) { |n| "life tape post #{n}" }
  #   sequence(:number_views) { |n| n * 10 }
  #
  #   association :user, factory: :ordinary_user
  #   association :project, factory: :core_project
  #
  #   after(:create) do |post|
  #     post.aspect = create :aspect, project: post.project
  #     post.save
  #     create :core_aspects_life_tape_posts, core_aspect: post.aspect, collect_info_post: post
  #   end
  # end
  #
  # factory :collect_info_comment, class: 'CollectInfo::Comment' do
  #   sequence(:content) { |n| "life tape comment #{n}" }
  #
  #   association :user, factory: :ordinary_user
  #   association :post, factory: :collect_info_post
  # end

  factory :aspect_question, class: 'Aspect::Question' do
    sequence(:content) { |n| "aspect question #{n}" }
    sequence(:hint) { |n| "aspect hint #{n}" }
    status 0
    type_stage 0
    association :user
    association :project, factory: :core_project
    association :aspect, factory: :aspect
  end

  factory :aspect_answer, class: 'Aspect::Answer' do
    sequence(:content) { |n| "aspect answer #{n}" }
    status 0
    correct true
    association :user
    association :question, factory: :aspect_question
  end

  factory :aspect_user_answer, class: 'Aspect::UserAnswer' do
    association :user, factory: :ordinary_user
    association :question, factory: :aspect_question
    association :project, factory: :core_project
    association :aspect, factory: :aspect
  end

  factory :aspect_voting, class: 'Aspect::Voting' do
    association :user, factory: :ordinary_user
    association :aspect, factory: :aspect
  end

  factory :aspect, class: 'Aspect::Post' do
    sequence(:content) { |n| "aspect #{n}" }
    association :user
    association :project, factory: :core_project
  end

  factory :aspect_comment, class: 'Aspect::Comment' do
    sequence(:content) { |n| "aspect comment #{n}" }

    association :user, factory: :ordinary_user
    association :post, factory: :aspect
  end
end
