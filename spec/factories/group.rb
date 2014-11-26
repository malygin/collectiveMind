FactoryGirl.define do
  factory :group, class: 'Group' do
    sequence(:name) { |n| "Group #{n}" }
    sequence(:description) { |n| "Description for group #{n}" }
  end

  factory :group_user, class: 'GroupUser'

  factory :group_owner, class: 'GroupUser' do
    owner true
    invite_accepted true
  end

  factory :group_task, class: 'GroupTask' do
    sequence(:name) { |n| "Group task #{n}" }
    sequence(:description) { |n| "Description for group task #{n}" }
  end
end
