FactoryGirl.define do
  factory :estimate, :class => 'Estimate::Post'  do
    sequence(:content) { |n| "content #{n}" }
    status 0
  end
  factory :estimate_aspect, :class => 'Estimate::PostAspect'  do
  end

end