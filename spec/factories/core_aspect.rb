FactoryGirl.define do
  factory :core_aspect, class: 'Core::Aspect' do
    sequence(:content) { |n| "aspect #{n}" }
  end
end