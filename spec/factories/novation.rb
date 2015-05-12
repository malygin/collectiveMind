FactoryGirl.define do
  factory :novation, class: 'Novation::Post' do
    sequence(:title) { |n| "what #{n}" }
    association :user, factory: :ordinary_user
    association :project, factory: :core_project

    after(:create) do |post|
      concept1 = create :concept, project: post.project
      concept2 = create :concept, project: post.project
      create :novation_post_concept, post_id: post.id, concept_post_id: concept1.id
      create :novation_post_concept, post_id: post.id, concept_post_id: concept2.id
    end
  end

  factory :novation_post_concept, class: 'Novation::PostConcept' do
    association :concept_post, factory: :concept
    association :post, factory: :novation
  end
end
