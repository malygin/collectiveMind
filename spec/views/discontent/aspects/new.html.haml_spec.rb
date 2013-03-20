require 'spec_helper'

describe "discontent/aspects/new" do
  before(:each) do
    assign(:discontent_aspect, stub_model(Discontent::Aspect,
      :content => "MyText",
      :user_id => 1
    ).as_new_record)
  end

  it "renders new discontent_aspect form" do
    # render

    # # Run the generator again with the --webrat flag if you want to use webrat matchers
    # assert_select "form", :action => discontent_aspects_path, :method => "post" do
    #   assert_select "textarea#discontent_aspect_content", :name => "discontent_aspect[content]"
    #   assert_select "input#discontent_aspect_user_id", :name => "discontent_aspect[user_id]"
    # end
  end
end
