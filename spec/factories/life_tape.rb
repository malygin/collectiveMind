
FactoryGirl.define do

  factory :discontent_aspect, :class => 'Discontent::Aspect'  do
    sequence(:content) { |n| "aspect #{n}" }
  end

  factory :life_tape_post, :class => 'LifeTape::Post'  do
    content  "life tape post for project"
    sequence(:number_views) { |n| n*10 }
    #factory :life_tape_post_with_discontent_aspect do
    #  after(:create) do |life_tape_post|
    #    FactoryGirl.create_list(:discontent_aspect, life_tape_posts: [life_tape_post])
    #  end
    #end
  end

  factory :life_tape_comment, :class => 'LifeTape::Comment'  do
    content  "life tape comment for post"
  end

  #factory :life_tape_post_with_discontent_aspect, :parent => :life_tape_post do
  #  discontent_aspects {[FactoryGirl.create(:discontent_aspect)]}
  #end
  #after(:create) {|life_tape_post| life_tape_post.discontent_aspects = [create(:discontent_aspect)]}
  #factory :life_tape_post, :class => 'LifeTape::Post' do |f|
  #  f.discontent_aspects { |a| [a.association(:discontent_aspect)] }
  #end

end
