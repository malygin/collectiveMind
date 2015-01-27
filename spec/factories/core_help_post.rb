FactoryGirl.define do
  factory :core_help_post, class: 'Core::Help::Post' do
    sequence(:content) { |n| "content for help #{n}" }
    sequence(:title) { |n| "title for help #{n}" }
    mini false
    style 1
    stage 1
  end
end
