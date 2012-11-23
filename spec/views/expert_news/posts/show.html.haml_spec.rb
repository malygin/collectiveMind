require 'spec_helper'

describe "expert_news/posts/show" do
  before(:each) do
    @expert_news_post = assign(:expert_news_post, stub_model(ExpertNews::Post,
      :title => "Title",
      :anons => "Anons",
      :content => "Content",
      :user_id => 1
    ))
  end

  it "renders attributes in <p>" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/Title/)
    rendered.should match(/Anons/)
    rendered.should match(/Content/)
    rendered.should match(/1/)
  end
end
