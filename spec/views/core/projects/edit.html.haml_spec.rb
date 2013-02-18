require 'spec_helper'

describe "core/projects/edit" do
  before(:each) do
    @core_project = assign(:core_project, stub_model(Core::Project,
      :name => "MyString",
      :desc => "MyText",
      :short_desc => "MyText",
      :status => 1
    ))
  end

  it "renders the edit core_project form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => core_projects_path(@core_project), :method => "post" do
      assert_select "input#core_project_name", :name => "core_project[name]"
      assert_select "textarea#core_project_desc", :name => "core_project[desc]"
      assert_select "textarea#core_project_short_desc", :name => "core_project[short_desc]"
      assert_select "input#core_project_status", :name => "core_project[status]"
    end
  end
end
