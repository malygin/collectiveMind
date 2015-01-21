FactoryGirl.define do
  factory :estimate, class: 'Estimate::Post' do
    sequence(:content) { |n| "content #{n}" }
    status 0
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

  factory :estimate_aspect, class: 'Estimate::PostAspect' do
    op1 0
    op2 0
    op3 0
    op4 0
    on1 0
    on2 0
    on3 0
    on4 0
    ozf1 0
    ozf2 0
    ozf3 0
    ozf4 0
    ozs1 0
    ozs2 0
    ozs3 0
    ozs4 0
  end
end
