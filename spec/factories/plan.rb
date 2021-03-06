FactoryGirl.define do
  factory :plan, class: 'Plan::Post' do
    sequence(:name) { |n| "name #{n}" }
    sequence(:goal) { |n| "goal #{n}" }
    sequence(:content) { |n| "content #{n}" }
    status 0

    association :user, factory: :ordinary_user
    association :project, factory: :core_project
  end

  factory :plan_novation, class: 'Plan::PostNovation' do
    sequence(:title) { |n| "title #{n}" }
    sequence(:project_goal) { |n| "project_goal #{n}" }

    association :plan_post, factory: :plan
    association :novation_post, factory: :novation
  end

  factory :plan_voting, class: 'Plan::Voting' do
    association :user
    association :plan_post, factory: :plan
  end

  factory :plan_comment, class: 'Plan::Comment' do
    sequence(:content) { |n| "plan comment #{n}" }

    association :user, factory: :ordinary_user
    association :post, factory: :plan
  end
end
