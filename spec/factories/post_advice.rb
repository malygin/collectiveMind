FactoryGirl.define do
  factory :advice, class: 'Discontent::PostAdvice'  do
    sequence(:content) { |n| "Advice number #{n}" }
  end
end
