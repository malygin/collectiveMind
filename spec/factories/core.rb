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
    association :user
    association :core_project
  end

  factory :aspect, class: 'Core::Aspect' do
    sequence(:content) { |n| "aspect #{n}" }
    association :user
    association :project, factory: :core_project
  end

  factory :core_help_post, class: 'Core::Help::Post' do
    sequence(:content) { |n| "content for help #{n}" }
    sequence(:title) { |n| "title for help #{n}" }
    mini false
    style 1
    stage 1
  end

  factory :core_knowbase_post, class: 'Core::Knowbase::Post' do
    sequence(:title) { |n| "title for knowbase #{n}" }
    sequence(:content) { |n| "content for knowbase #{n}" }
    sequence(:stage) { |n| n }

    association :aspect
  end
end
