FactoryGirl.define do
  factory :advice_comment, class: 'AdviceComment' do
    sequence(:content) { |n| "Comment to advice number #{n}" }
  end
end
