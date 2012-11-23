require 'spec_helper'

describe "expert_news/posts/index" do
  before(:each) do
    assign(:expert_news_posts, [
      stub_model(ExpertNews::Post,
        :title => "Title",
        :anons => "Anons",
        :content => "Content",
        :user_id => 1
      ),
      stub_model(ExpertNews::Post,
        :title => "Title",
        :anons => "Anons",
        :content => "Content",
        :user_id => 1
      )
    ])
  end

  it "renders a list of expert_news/posts" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => "Title".to_s, :count => 2
    assert_select "tr>td", :text => "Anons".to_s, :count => 2
    assert_select "tr>td", :text => "Content".to_s, :count => 2
    assert_select "tr>td", :text => 1.to_s, :count => 2
  end
end
