require 'spec_helper'

describe "core/projects/show" do
  before(:each) do
    @core_project = assign(:core_project, stub_model(Core::Project,
      :name => "Name",
      :desc => "MyText",
      :short_desc => "MyText",
      :status => 1
    ))
  end

  it "renders attributes in <p>" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/Name/)
    rendered.should match(/MyText/)
    rendered.should match(/MyText/)
    rendered.should match(/1/)
  end
end
