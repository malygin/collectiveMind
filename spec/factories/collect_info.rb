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
  #     create :discontent_aspects_life_tape_posts, discontent_aspect: post.aspect, collect_info_post: post
  #   end
  # end

  # factory :life_tape_comment, class: 'CollectInfo::Comment' do
  #   sequence(:content) { |n| "life tape comment #{n}" }
  #
  #   association :user, factory: :ordinary_user
  #   association :post, factory: :collect_info_post
  # end

  factory :collect_info_question, class: 'CollectInfo::Question' do
    sequence(:content) { |n| "collect info question #{n}" }

    association :post, factory: :core_aspect
    association :project, factory: :core_project
  end

  factory :collect_info_answer, class: 'CollectInfo::Answer' do
    sequence(:content) { |n| "collect info answer #{n}" }
    style 0

    association :post, factory: :core_aspect
    association :question, factory: :collect_info_question
  end

  factory :collect_info_answers_user, class: 'CollectInfo::AnswersUser' do

    association :user, factory: :ordinary_user
    association :answer, factory: :collect_info_answer
    association :question, factory: :collect_info_question
    association :project, factory: :core_project
  end

  factory :collect_info_voting, class: 'CollectInfo::Voting' do

    association :user, factory: :ordinary_user
    association :post, factory: :core_aspect
  end
end
