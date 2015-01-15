FactoryGirl.define do

  factory :core_project, class: 'Core::Project' do
    sequence(:name) { |n| "Project #{n}" }
    type_project 0
    type_access 0
    status 1
  end

  factory :core_project_user, class: 'Core::ProjectUser' do
  end

end