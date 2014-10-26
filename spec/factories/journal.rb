FactoryGirl.define do
  factory :journal, class: 'Journal' do
    type_event 'life_tape_comment_save'
    sequence(:body) { |n| "body #{n}" }
    sequence(:body2) { |n| "body2 #{n}" }
    viewed false
    personal false

    factory :personal_journal do
      personal true
    end
  end
end
