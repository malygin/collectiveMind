require 'spec_helper'

describe "life_tape_posts/show" do
  before(:each) do
    @post = assign(:post, stub_model(LifeTape::Post))
  end

  it "renders attributes in <p>" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
  end
end
