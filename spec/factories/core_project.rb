FactoryGirl.define do
  factory :core_project, class: 'Core::Project' do
    sequence(:name) { |n| "Project #{n}" }
    type_access 0
    status 1

    factory :closed_project do
      type_access Core::Project::TYPE_ACCESS_CODE[:closed]
    end

    factory :club_project do
      type_access Core::Project::TYPE_ACCESS_CODE[:club]
    end
  end

  factory :core_project_user, class: 'Core::ProjectUser' do
  end
end
