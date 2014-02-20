
FactoryGirl.define do

  factory :help_post, class: 'Help::Post' do
    sequence(:content) {|n| "content for help #{n}"}
    sequence(:title) {|n| "title for help #{n}"}
    mini false
    style 1
    stage 1
  end

  factory :help_question, class: 'Help::Question' do
    sequence(:content) {|n| "content for question #{n}"}
    style 1
  end

  factory :help_answer, class: 'Help::Answer' do
    sequence(:content) {|n| "content for answer #{n}"}
  end

end