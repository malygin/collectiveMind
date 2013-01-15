require 'spec_helper'

describe "estimate/posts/index" do
  before(:each) do
    assign(:estimate_posts, [
      stub_model(Estimate::Post,
        :user_id => 1,
        :post_id => 2,
        :content => "MyText",
        :oppsh1 => 3,
        :oppsh2 => 4,
        :oppsh3 => 5,
        :oppsh => "MyText",
        :ozpshf1 => 6,
        :ozpshf2 => 7,
        :ozpshf3 => 8,
        :ozpshf => "MyText",
        :ozpshs1 => 9,
        :ozpshs2 => 10,
        :ozpshs3 => 11,
        :ozpshs => "MyText",
        :onpsh1 => 12,
        :onpsh2 => 13,
        :onpsh3 => 14,
        :onpsh => "MyText",
        :nepr1 => 15,
        :nepr2 => 16,
        :nepr3 => 17,
        :nepr4 => 18,
        :nepr => "MyText"
      ),
      stub_model(Estimate::Post,
        :user_id => 1,
        :post_id => 2,
        :content => "MyText",
        :oppsh1 => 3,
        :oppsh2 => 4,
        :oppsh3 => 5,
        :oppsh => "MyText",
        :ozpshf1 => 6,
        :ozpshf2 => 7,
        :ozpshf3 => 8,
        :ozpshf => "MyText",
        :ozpshs1 => 9,
        :ozpshs2 => 10,
        :ozpshs3 => 11,
        :ozpshs => "MyText",
        :onpsh1 => 12,
        :onpsh2 => 13,
        :onpsh3 => 14,
        :onpsh => "MyText",
        :nepr1 => 15,
        :nepr2 => 16,
        :nepr3 => 17,
        :nepr4 => 18,
        :nepr => "MyText"
      )
    ])
  end

  it "renders a list of estimate/posts" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => 1.to_s, :count => 2
    assert_select "tr>td", :text => 2.to_s, :count => 2
    assert_select "tr>td", :text => "MyText".to_s, :count => 2
    assert_select "tr>td", :text => 3.to_s, :count => 2
    assert_select "tr>td", :text => 4.to_s, :count => 2
    assert_select "tr>td", :text => 5.to_s, :count => 2
    assert_select "tr>td", :text => "MyText".to_s, :count => 2
    assert_select "tr>td", :text => 6.to_s, :count => 2
    assert_select "tr>td", :text => 7.to_s, :count => 2
    assert_select "tr>td", :text => 8.to_s, :count => 2
    assert_select "tr>td", :text => "MyText".to_s, :count => 2
    assert_select "tr>td", :text => 9.to_s, :count => 2
    assert_select "tr>td", :text => 10.to_s, :count => 2
    assert_select "tr>td", :text => 11.to_s, :count => 2
    assert_select "tr>td", :text => "MyText".to_s, :count => 2
    assert_select "tr>td", :text => 12.to_s, :count => 2
    assert_select "tr>td", :text => 13.to_s, :count => 2
    assert_select "tr>td", :text => 14.to_s, :count => 2
    assert_select "tr>td", :text => "MyText".to_s, :count => 2
    assert_select "tr>td", :text => 15.to_s, :count => 2
    assert_select "tr>td", :text => 16.to_s, :count => 2
    assert_select "tr>td", :text => 17.to_s, :count => 2
    assert_select "tr>td", :text => 18.to_s, :count => 2
    assert_select "tr>td", :text => "MyText".to_s, :count => 2
  end
end
