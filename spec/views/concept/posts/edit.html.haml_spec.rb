require 'spec_helper'

describe "concept/posts/edit" do
  before(:each) do
    @concept_post = assign(:concept_post, stub_model(Concept::Post,
      :goal => "MyText",
      :reality => "MyText",
      :user_id => 1,
      :number_views => 1,
      :life_tape_post_id => 1
    ))
  end

  it "renders the edit concept_post form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => concept_posts_path(@concept_post), :method => "post" do
      assert_select "textarea#concept_post_goal", :name => "concept_post[goal]"
      assert_select "textarea#concept_post_reality", :name => "concept_post[reality]"
      assert_select "input#concept_post_user_id", :name => "concept_post[user_id]"
      assert_select "input#concept_post_number_views", :name => "concept_post[number_views]"
      assert_select "input#concept_post_life_tape_post_id", :name => "concept_post[life_tape_post_id]"
    end
  end
end
