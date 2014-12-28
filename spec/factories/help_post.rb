FactoryGirl.define do
  factory :help_post, class: 'Help::Post' do
    sequence(:content) { |n| "content for help #{n}" }
    sequence(:title) { |n| "title for help #{n}" }
    mini false
    style 1
    stage 1
  end
end
