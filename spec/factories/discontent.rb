
FactoryGirl.define do
  factory :aspect, :class => 'Discontent::Aspect'  do
    sequence(:content) { |n| "aspect #{n}" }
  end

end