require 'spec_helper'

describe "concept/posts/index" do
  before(:each) do
    assign(:concept_posts, [
      stub_model(Concept::Post,
        :goal => "MyText",
        :reality => "MyText",
        :user_id => 1,
        :number_views => 2,
        :life_tape_post_id => 3
      ),
      stub_model(Concept::Post,
        :goal => "MyText",
        :reality => "MyText",
        :user_id => 1,
        :number_views => 2,
        :life_tape_post_id => 3
      )
    ])
  end

  it "renders a list of concept/posts" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => "MyText".to_s, :count => 2
    assert_select "tr>td", :text => "MyText".to_s, :count => 2
    assert_select "tr>td", :text => 1.to_s, :count => 2
    assert_select "tr>td", :text => 2.to_s, :count => 2
    assert_select "tr>td", :text => 3.to_s, :count => 2
  end
end
