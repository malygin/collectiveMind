require 'spec_helper'

describe "plan/posts/index" do
  before(:each) do
    assign(:plan_posts, [
      stub_model(Plan::Post,
        :user_id => 1,
        :goal => "MyText",
        :first_step => "MyText",
        :other_steps => "MyText",
        :status => 2,
        :number_views => 3
      ),
      stub_model(Plan::Post,
        :user_id => 1,
        :goal => "MyText",
        :first_step => "MyText",
        :other_steps => "MyText",
        :status => 2,
        :number_views => 3
      )
    ])
  end

  it "renders a list of plan/posts" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => 1.to_s, :count => 2
    assert_select "tr>td", :text => "MyText".to_s, :count => 2
    assert_select "tr>td", :text => "MyText".to_s, :count => 2
    assert_select "tr>td", :text => "MyText".to_s, :count => 2
    assert_select "tr>td", :text => 2.to_s, :count => 2
    assert_select "tr>td", :text => 3.to_s, :count => 2
  end
end
