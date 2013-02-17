require 'spec_helper'

describe "discontent/posts/show" do
  before(:each) do
    @discontent_post = assign(:discontent_post, stub_model(Discontent::Post,
      :content => "MyText",
      :when => "MyText",
      :where => "MyText",
      :user_id => 1,
      :status => 2
    ))
  end

  it "renders attributes in <p>" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/MyText/)
    rendered.should match(/MyText/)
    rendered.should match(/MyText/)
    rendered.should match(/1/)
    rendered.should match(/2/)
  end
end
