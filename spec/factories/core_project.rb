
FactoryGirl.define do
  factory :core_project, :class => 'Core::Project'  do
    name  "test project"
    type_project 0
    type_access 0
    status 1
  end

end