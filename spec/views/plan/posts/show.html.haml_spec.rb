require 'spec_helper'

describe "plan/posts/show" do
  before(:each) do
    @plan_post = assign(:plan_post, stub_model(Plan::Post,
      :user_id => 1,
      :goal => "MyText",
      :first_step => "MyText",
      :other_steps => "MyText",
      :status => 2,
      :number_views => 3
    ))
  end

  it "renders attributes in <p>" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/1/)
    rendered.should match(/MyText/)
    rendered.should match(/MyText/)
    rendered.should match(/MyText/)
    rendered.should match(/2/)
    rendered.should match(/3/)
  end
end
