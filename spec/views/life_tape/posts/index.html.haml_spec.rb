require 'spec_helper'

describe "life_tape_posts/index" do
  before(:each) do
    assign(:life_tape_posts, [
      stub_model(LifeTape::Post),
      stub_model(LifeTape::Post)
    ])
  end

  it "renders a list of life_tape_posts" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
  end
end
