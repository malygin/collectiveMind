FactoryGirl.define do
  factory :concept, :class => 'Concept::Post'  do
    status 0
  end
  factory :concept_aspect, :class => 'Concept::PostAspect'  do
    sequence(:positive) { |n| "positive #{n}" }
    sequence(:negative) { |n| "negative #{n}" }
    sequence(:title) { |n| "title #{n}" }
    sequence(:name) { |n| "name #{n}" }
    sequence(:control) { |n| "control #{n}" }
    sequence(:content) { |n| "content #{n}" }
    sequence(:reality) { |n| "reality #{n}" }
    sequence(:problems) { |n| "problems #{n}" }
  end

  factory :concept_post_discontent, :class => 'Concept::PostDiscontent'  do
  end
  factory :concept_comment, :class => 'Concept::Comment'  do
    content "concept comment for post"
  end
end