require 'spec_helper'

describe "core/projects/index" do
  before(:each) do
    assign(:core_projects, [
      stub_model(Core::Project,
        :name => "Name",
        :desc => "MyText",
        :short_desc => "MyText",
        :status => 1
      ),
      stub_model(Core::Project,
        :name => "Name",
        :desc => "MyText",
        :short_desc => "MyText",
        :status => 1
      )
    ])
  end

  it "renders a list of core/projects" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => "Name".to_s, :count => 2
    assert_select "tr>td", :text => "MyText".to_s, :count => 2
    assert_select "tr>td", :text => "MyText".to_s, :count => 2
    assert_select "tr>td", :text => 1.to_s, :count => 2
  end
end
