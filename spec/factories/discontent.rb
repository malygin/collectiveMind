
FactoryGirl.define do
  factory :aspect, :class => 'Discontent::Aspect'  do
    sequence(:content) { |n| "aspect #{n}" }
  end
  factory :discontent, :class => 'Discontent::Post'  do
    sequence(:content) { |n| "what #{n}" }
    sequence(:whend) { |n| "whend #{n}" }
    sequence(:whered) { |n| "whered #{n}" }
  end
  factory :discontent_union, :class => 'Discontent::Post'  do
    status 2
  end
end