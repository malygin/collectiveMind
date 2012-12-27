require 'spec_helper'

describe "plan/posts/new" do
  before(:each) do
    assign(:plan_post, stub_model(Plan::Post,
      :user_id => 1,
      :goal => "MyText",
      :first_step => "MyText",
      :other_steps => "MyText",
      :status => 1,
      :number_views => 1
    ).as_new_record)
  end

  it "renders new plan_post form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => plan_posts_path, :method => "post" do
      assert_select "input#plan_post_user_id", :name => "plan_post[user_id]"
      assert_select "textarea#plan_post_goal", :name => "plan_post[goal]"
      assert_select "textarea#plan_post_first_step", :name => "plan_post[first_step]"
      assert_select "textarea#plan_post_other_steps", :name => "plan_post[other_steps]"
      assert_select "input#plan_post_status", :name => "plan_post[status]"
      assert_select "input#plan_post_number_views", :name => "plan_post[number_views]"
    end
  end
end
