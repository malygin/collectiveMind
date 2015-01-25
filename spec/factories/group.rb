FactoryGirl.define do
  factory :group, class: 'Util::Unit::Group' do
    sequence(:name) { |n| "Group #{n}" }
    sequence(:description) { |n| "Description for group #{n}" }
  end

  factory :group_user, class: 'Util::Unit::GroupUser'

  factory :group_owner, class: 'Util::Unit::GroupUser' do
    owner true
    invite_accepted true
  end

  factory :group_task, class: 'Util::Unit::GroupTask' do
    sequence(:name) { |n| "Group task #{n}" }
    sequence(:description) { |n| "Description for group task #{n}" }
  end
end
