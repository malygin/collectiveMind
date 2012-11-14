require 'spec_helper'

describe "life_tape_posts/new" do
  before(:each) do
    assign(:post, stub_model(LifeTape::Post).as_new_record)
  end

  it "renders new post form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => life_tape_posts_path, :method => "post" do
    end
  end
end
