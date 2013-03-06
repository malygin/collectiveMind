require 'spec_helper'

describe ApplicationHelper do
  
  describe "cp for stages for life tape" do
    
    it "should not be current for root" do
      helper.request.env['REQUEST_PATH'] = '/'
      helper.cp('/life_tape/posts', 'life_tape').should == nil
    end

    it "should be current for life_tape path" do
      helper.request.env['REQUEST_PATH'] = '/life_tape'
      helper.cp('/life_tape/posts', 'life_tape').should == 'current'
    end
  end
end