FactoryGirl.define do
  factory :plan, class: 'Plan::Post' do
    sequence(:name) { |n| "name #{n}" }
    sequence(:goal) { |n| "goal #{n}" }
    sequence(:content) { |n| "content #{n}" }
    status 0

    association :user, factory: :ordinary_user
    association :project, factory: :core_project
  end

  factory :plan_stage, class: 'Plan::PostStage' do
    sequence(:name) { |n| "name #{n}" }
    sequence(:desc) { |n| "desc #{n}" }
    status 0
  end

  factory :plan_aspect, class: 'Plan::PostAspect' do
    sequence(:positive) { |n| "positive #{n}" }
    sequence(:negative) { |n| "negative #{n}" }
    sequence(:title) { |n| "title #{n}" }
    sequence(:name) { |n| "name #{n}" }
    sequence(:control) { |n| "control #{n}" }
    sequence(:content) { |n| "content #{n}" }
    sequence(:reality) { |n| "reality #{n}" }
    sequence(:problems) { |n| "problems #{n}" }
  end

  factory :plan_action, class: 'Plan::PostAction' do
    sequence(:name) { |n| "name #{n}" }
    sequence(:desc) { |n| "desc #{n}" }
    status 0
  end

  factory :plan_voting, class: 'Plan::Voting' do
    association :user
    association :plan_post, factory: :plan
  end
end
