require 'spec_helper'

describe "discontent/aspects/show" do
  before(:each) do
    @discontent_aspect = assign(:discontent_aspect, stub_model(Discontent::Aspect,
      :content => "MyText",
      :user_id => 1
    ))
  end

  it "renders attributes in <p>" do
    # render
    # # Run the generator again with the --webrat flag if you want to use webrat matchers
    # rendered.should match(/MyText/)
    # rendered.should match(/1/)
  end
end
