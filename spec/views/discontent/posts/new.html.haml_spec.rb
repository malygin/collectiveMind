require 'spec_helper'

describe "discontent/posts/new" do
  before(:each) do
    assign(:discontent_post, stub_model(Discontent::Post,
      :content => "MyText",
      :when => "MyText",
      :where => "MyText",
      :user_id => 1,
      :status => 1
    ).as_new_record)
  end

  it "renders new discontent_post form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => discontent_posts_path, :method => "post" do
      assert_select "textarea#discontent_post_content", :name => "discontent_post[content]"
      assert_select "textarea#discontent_post_when", :name => "discontent_post[when]"
      assert_select "textarea#discontent_post_where", :name => "discontent_post[where]"
      assert_select "input#discontent_post_user_id", :name => "discontent_post[user_id]"
      assert_select "input#discontent_post_status", :name => "discontent_post[status]"
    end
  end
end
