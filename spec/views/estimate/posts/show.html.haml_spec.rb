require 'spec_helper'

describe "estimate/posts/show" do
  before(:each) do
    @estimate_post = assign(:estimate_post, stub_model(Estimate::Post,
      :user_id => 1,
      :post_id => 2,
      :content => "MyText",
      :oppsh1 => 3,
      :oppsh2 => 4,
      :oppsh3 => 5,
      :oppsh => "MyText",
      :ozpshf1 => 6,
      :ozpshf2 => 7,
      :ozpshf3 => 8,
      :ozpshf => "MyText",
      :ozpshs1 => 9,
      :ozpshs2 => 10,
      :ozpshs3 => 11,
      :ozpshs => "MyText",
      :onpsh1 => 12,
      :onpsh2 => 13,
      :onpsh3 => 14,
      :onpsh => "MyText",
      :nepr1 => 15,
      :nepr2 => 16,
      :nepr3 => 17,
      :nepr4 => 18,
      :nepr => "MyText"
    ))
  end

  it "renders attributes in <p>" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/1/)
    rendered.should match(/2/)
    rendered.should match(/MyText/)
    rendered.should match(/3/)
    rendered.should match(/4/)
    rendered.should match(/5/)
    rendered.should match(/MyText/)
    rendered.should match(/6/)
    rendered.should match(/7/)
    rendered.should match(/8/)
    rendered.should match(/MyText/)
    rendered.should match(/9/)
    rendered.should match(/10/)
    rendered.should match(/11/)
    rendered.should match(/MyText/)
    rendered.should match(/12/)
    rendered.should match(/13/)
    rendered.should match(/14/)
    rendered.should match(/MyText/)
    rendered.should match(/15/)
    rendered.should match(/16/)
    rendered.should match(/17/)
    rendered.should match(/18/)
    rendered.should match(/MyText/)
  end
end
