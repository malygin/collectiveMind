FactoryGirl.define do
  factory :core_project, class: 'Core::Project' do
    sequence(:name) { |n| "Project #{n}" }
    type_access 0
    stage '1:0'

    factory :closed_project do
      type_access Core::Project::TYPE_ACCESS[:closed][:code]
    end

    factory :club_project do
      type_access Core::Project::TYPE_ACCESS[:club][:code]
    end

    after(:create) do |project|
      stage_name = ProjectDecorator.new(project).current_stage_type.to_s
      technique_1 = Technique::List.create stage: stage_name, code: 'simple'
      project.techniques << technique_1
    end
  end

  factory :core_project_user, class: 'Core::ProjectUser' do
    association :user
    association :core_project
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

    association :aspect, factory: :aspect
  end

end
