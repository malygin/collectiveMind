FactoryGirl.define do
  factory :advice_unapproved, class: 'Advice' do
    sequence(:content) { |n| "Advice number #{n}" }

    factory :advice_approved do
      approved true
    end

    factory :advice_useful do
      useful true
    end

    factory :advice_disapproved do
      approved false
    end
  end

  factory :advice_comment, class: 'AdviceComment' do
    sequence(:content) { |n| "Comment to advice number #{n}" }
  end
end
