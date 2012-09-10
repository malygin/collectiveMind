require 'spec_helper'

describe "tests/edit" do
  before(:each) do
    @test = assign(:test, stub_model(Test,
      :name => "MyString",
      :description => "MyString",
      :project_id => 1
    ))
  end

  it "renders the edit test form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => tests_path(@test), :method => "post" do
      assert_select "input#test_name", :name => "test[name]"
      assert_select "input#test_description", :name => "test[description]"
      assert_select "input#test_project_id", :name => "test[project_id]"
    end
  end
end
