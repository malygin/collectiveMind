FactoryGirl.define do
  factory :knowbase_post, :class => 'Knowbase::Post'  do
    sequence(:title) {|n| "title for knowbase #{n}"}
    sequence(:content) {|n| "content for knowbase #{n}"}
    sequence(:stage) { |n| n }
  end
end
