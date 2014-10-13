FactoryGirl.define do
  factory :advice_comment, class: 'Discontent::PostAdviceComment' do
    sequence(:content) { |n| "Comment to advice number #{n}" }
  end
end
