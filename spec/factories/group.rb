FactoryGirl.define do
  factory :group, class: 'Group' do
    sequence(:name) { |n| "Group #{n}" }
    sequence(:description) { |n| "Description for group #{n}" }
  end
end
