require 'spec_helper'

describe "expert_news/posts/new" do
  before(:each) do
    assign(:expert_news_post, stub_model(ExpertNews::Post,
      :title => "MyString",
      :anons => "MyString",
      :content => "MyString",
      :user_id => 1
    ).as_new_record)
  end

  it "renders new expert_news_post form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => expert_news_posts_path, :method => "post" do
      assert_select "input#expert_news_post_title", :name => "expert_news_post[title]"
      assert_select "input#expert_news_post_anons", :name => "expert_news_post[anons]"
      assert_select "input#expert_news_post_content", :name => "expert_news_post[content]"
      assert_select "input#expert_news_post_user_id", :name => "expert_news_post[user_id]"
    end
  end
end
