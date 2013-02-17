require 'spec_helper'

describe "discontent/posts/index" do
  before(:each) do
    assign(:discontent_posts, [
      stub_model(Discontent::Post,
        :content => "MyText",
        :when => "MyText",
        :where => "MyText",
        :user_id => 1,
        :status => 2
      ),
      stub_model(Discontent::Post,
        :content => "MyText",
        :when => "MyText",
        :where => "MyText",
        :user_id => 1,
        :status => 2
      )
    ])
  end

  it "renders a list of discontent/posts" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => "MyText".to_s, :count => 2
    assert_select "tr>td", :text => "MyText".to_s, :count => 2
    assert_select "tr>td", :text => "MyText".to_s, :count => 2
    assert_select "tr>td", :text => 1.to_s, :count => 2
    assert_select "tr>td", :text => 2.to_s, :count => 2
  end
end
