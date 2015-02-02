FactoryGirl.define do
  factory :concept, class: 'Concept::Post' do
    status 0

    after :create do |post|
      discontent = create :discontent, project: post.project, status: 4
      create :concept_aspect, discontent_aspect_id: discontent.id, concept_post_id: post.id
      create :concept_post_discontent, post_id: post.id, discontent_post_id: discontent.id
    end
  end

  factory :concept_aspect, class: 'Concept::PostAspect' do
    sequence(:positive) { |n| "positive #{n}" }
    sequence(:negative) { |n| "negative #{n}" }
    sequence(:title) { |n| "title #{n}" }
    sequence(:name) { |n| "name #{n}" }
    sequence(:control) { |n| "control #{n}" }
    sequence(:content) { |n| "content #{n}" }
    sequence(:reality) { |n| "reality #{n}" }
    sequence(:problems) { |n| "problems #{n}" }
  end

  factory :concept_post_discontent, class: 'Concept::PostDiscontent' do
  end

  factory :concept_comment, class: 'Concept::Comment' do
    sequence(:content) { |n| "concept comment #{n}" }

    association :user, factory: :ordinary_user
    association :post, factory: :concept
  end
end
