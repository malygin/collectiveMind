
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
  factory :discontent_post_aspect, :class => 'Discontent::PostAspect'  do
  end
  factory :discontent_comment, :class => 'Discontent::Comment'  do
    content  "discontent comment for post"
  end
end

#Factory.define :aspect do |f|
#  f.life_tape_posts { |a| [a.association(:aspect)] }
#end
#
#factory :aspect_with_post, :parent => :aspect do
#  life_tape_posts {[FactoryGirl.create(:life_tape_post)]}
#end