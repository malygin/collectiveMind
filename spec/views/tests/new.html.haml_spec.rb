require 'spec_helper'

describe "tests/new" do
  before(:each) do
    assign(:test, stub_model(Test,
      :name => "MyString",
      :description => "MyString",
      :project_id => 1
    ).as_new_record)
  end

  it "renders new test form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => tests_path, :method => "post" do
      assert_select "input#test_name", :name => "test[name]"
      assert_select "input#test_description", :name => "test[description]"
      assert_select "input#test_project_id", :name => "test[project_id]"
    end
  end
end
