FactoryGirl.define do
  factory :advice, class: 'Advice'  do
    sequence(:content) { |n| "Advice number #{n}" }
  end
end
