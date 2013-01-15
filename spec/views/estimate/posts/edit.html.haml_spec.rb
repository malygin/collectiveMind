require 'spec_helper'

describe "estimate/posts/edit" do
  before(:each) do
    @estimate_post = assign(:estimate_post, stub_model(Estimate::Post,
      :user_id => 1,
      :post_id => 1,
      :content => "MyText",
      :oppsh1 => 1,
      :oppsh2 => 1,
      :oppsh3 => 1,
      :oppsh => "MyText",
      :ozpshf1 => 1,
      :ozpshf2 => 1,
      :ozpshf3 => 1,
      :ozpshf => "MyText",
      :ozpshs1 => 1,
      :ozpshs2 => 1,
      :ozpshs3 => 1,
      :ozpshs => "MyText",
      :onpsh1 => 1,
      :onpsh2 => 1,
      :onpsh3 => 1,
      :onpsh => "MyText",
      :nepr1 => 1,
      :nepr2 => 1,
      :nepr3 => 1,
      :nepr4 => 1,
      :nepr => "MyText"
    ))
  end

  it "renders the edit estimate_post form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => estimate_posts_path(@estimate_post), :method => "post" do
      assert_select "input#estimate_post_user_id", :name => "estimate_post[user_id]"
      assert_select "input#estimate_post_post_id", :name => "estimate_post[post_id]"
      assert_select "textarea#estimate_post_content", :name => "estimate_post[content]"
      assert_select "input#estimate_post_oppsh1", :name => "estimate_post[oppsh1]"
      assert_select "input#estimate_post_oppsh2", :name => "estimate_post[oppsh2]"
      assert_select "input#estimate_post_oppsh3", :name => "estimate_post[oppsh3]"
      assert_select "textarea#estimate_post_oppsh", :name => "estimate_post[oppsh]"
      assert_select "input#estimate_post_ozpshf1", :name => "estimate_post[ozpshf1]"
      assert_select "input#estimate_post_ozpshf2", :name => "estimate_post[ozpshf2]"
      assert_select "input#estimate_post_ozpshf3", :name => "estimate_post[ozpshf3]"
      assert_select "textarea#estimate_post_ozpshf", :name => "estimate_post[ozpshf]"
      assert_select "input#estimate_post_ozpshs1", :name => "estimate_post[ozpshs1]"
      assert_select "input#estimate_post_ozpshs2", :name => "estimate_post[ozpshs2]"
      assert_select "input#estimate_post_ozpshs3", :name => "estimate_post[ozpshs3]"
      assert_select "textarea#estimate_post_ozpshs", :name => "estimate_post[ozpshs]"
      assert_select "input#estimate_post_onpsh1", :name => "estimate_post[onpsh1]"
      assert_select "input#estimate_post_onpsh2", :name => "estimate_post[onpsh2]"
      assert_select "input#estimate_post_onpsh3", :name => "estimate_post[onpsh3]"
      assert_select "textarea#estimate_post_onpsh", :name => "estimate_post[onpsh]"
      assert_select "input#estimate_post_nepr1", :name => "estimate_post[nepr1]"
      assert_select "input#estimate_post_nepr2", :name => "estimate_post[nepr2]"
      assert_select "input#estimate_post_nepr3", :name => "estimate_post[nepr3]"
      assert_select "input#estimate_post_nepr4", :name => "estimate_post[nepr4]"
      assert_select "textarea#estimate_post_nepr", :name => "estimate_post[nepr]"
    end
  end
end
