require 'spec_helper'

describe "concept/posts/show" do
  before(:each) do
    @concept_post = assign(:concept_post, stub_model(Concept::Post,
      :goal => "MyText",
      :reality => "MyText",
      :user_id => 1,
      :number_views => 2,
      :life_tape_post_id => 3
    ))
  end

  it "renders attributes in <p>" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/MyText/)
    rendered.should match(/MyText/)
    rendered.should match(/1/)
    rendered.should match(/2/)
    rendered.should match(/3/)
  end
end
