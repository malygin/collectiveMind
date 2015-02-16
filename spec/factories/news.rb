FactoryGirl.define do
  factory :news do
    sequence(:title) { |n| "Anounce for #{n}" }
    sequence(:body) { |n| "Big body for #{n}" }

    association :project, factory: :core_project
    association :user, factory: :expert
  end
end
