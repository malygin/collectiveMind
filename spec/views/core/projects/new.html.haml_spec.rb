require 'spec_helper'

describe "core/projects/new" do
  before(:each) do
    assign(:core_project, stub_model(Core::Project,
      :name => "MyString",
      :desc => "MyText",
      :short_desc => "MyText",
      :status => 1
    ).as_new_record)
  end

  it "renders new core_project form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => core_projects_path, :method => "post" do
      assert_select "input#core_project_name", :name => "core_project[name]"
      assert_select "textarea#core_project_desc", :name => "core_project[desc]"
      assert_select "textarea#core_project_short_desc", :name => "core_project[short_desc]"
      assert_select "input#core_project_status", :name => "core_project[status]"
    end
  end
end
