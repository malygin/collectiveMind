FactoryGirl.define do
  factory :estimate, class: 'Estimate::Post' do
    sequence(:content) { |n| "content #{n}" }
    status 0

    association :user
    association :project, factory: :core_project
    association :post, factory: :plan
  end

  factory :estimate_aspect, class: 'Estimate::PostAspect' do
    nepr1 0
    nepr2 0
    nepr3 0
    nepr4 0
    nep1 0
    nep2 0
    nep3 0
    nep4 0

    association :user, factory: :ordinary_user
    association :post, factory: :plan
    association :project, factory: :core_project
  end

  factory :estimate_post_voting, class: 'Estimate::PostVoting' do
    association :user
    association :post, factory: :estimate
  end
end
