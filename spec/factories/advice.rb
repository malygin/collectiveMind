FactoryGirl.define do
  factory :advice_unapproved, class: 'Advice' do
    sequence(:content) { |n| "Advice number #{n}" }

    factory :advice_approved do
      approved true
    end
  end

  factory :advice_comment, class: 'AdviceComment' do
    sequence(:content) { |n| "Comment to advice number #{n}" }
  end
end
