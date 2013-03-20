require 'spec_helper'

describe "discontent/aspects/edit" do
  before(:each) do
    @discontent_aspect = assign(:discontent_aspect, stub_model(Discontent::Aspect,
      :content => "MyText",
      :user_id => 1
    ))
  end

  it "renders the edit discontent_aspect form" do
    # render

    # # Run the generator again with the --webrat flag if you want to use webrat matchers
    # assert_select "form", :action => discontent_aspects_path(@discontent_aspect), :method => "post" do
    #   assert_select "textarea#discontent_aspect_content", :name => "discontent_aspect[content]"
    #   assert_select "input#discontent_aspect_user_id", :name => "discontent_aspect[user_id]"
    # end
  end
end
