FactoryGirl.define do
  factory :concept, class: 'Concept::Post' do
    association :user
    association :project, factory: :core_project
    sequence(:title) { |n| "title #{n}" }
    sequence(:content) { |n| "content #{n}" }
    sequence(:goal) { |n| "goal #{n}" }
    sequence(:actors) { |n| "actors #{n}" }
    sequence(:impact_env) { |n| "impact_env #{n}" }

    after :create do |post|
      discontent = create :discontent_with_aspects, project: post.project, status: BasePost::STATUSES[:approved]
      create :concept_post_discontent, post_id: post.id, discontent_post_id: discontent.id
    end
  end

  factory :concept_post_discontent, class: 'Concept::PostDiscontent' do
  end

  factory :concept_comment, class: 'Concept::Comment' do
    sequence(:content) { |n| "concept comment #{n}" }

    association :user, factory: :ordinary_user
    association :post, factory: :concept
  end

  factory :concept_voting, class: 'Concept::Voting' do
    association :user
    association :discontent_post, factory: :discontent_with_aspects
    association :concept_post, factory: :concept
  end
end
