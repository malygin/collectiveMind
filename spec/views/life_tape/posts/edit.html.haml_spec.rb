require 'spec_helper'

describe "life_tape_posts/edit" do
  before(:each) do
    @post = assign(:post, stub_model(LifeTape::Post))
  end

  it "renders the edit post form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => life_tape_posts_path(@post), :method => "post" do
    end
  end
end
