FactoryGirl.define do
  factory :core_knowbase_post, class: 'Core::Knowbase::Post' do
    sequence(:title) { |n| "title for knowbase #{n}" }
    sequence(:content) { |n| "content for knowbase #{n}" }
    sequence(:stage) { |n| n }
  end
end
