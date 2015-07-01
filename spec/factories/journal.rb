FactoryGirl.define do
  factory :journal, class: 'Journal' do
    type_event 'aspect_comment_save'
    sequence(:body) { |n| "body #{n}" }
    sequence(:body2) { |n| "body2 #{n}" }
    viewed false
    personal false

    factory :personal_journal do
      personal true
    end

    association :user, factory: :ordinary_user
  end
end
