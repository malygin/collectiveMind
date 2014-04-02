#require 'spec_helper'
#describe 'Knowbase ' do
#  subject { page }
#  before :all do
#    @project.update_attribute(:status, 1)
#
#    30.times do |n|
#      lp = FactoryGirl.create :discontent, project: @project
#      lp.title = "title knowbase_#{n}"
#      lp.content = "content knowbase_#{n}"
#      lp.stage = n
#      lp.save
#    end
#    @post =  FactoryGirl.create :discontent, project: @project, title: 'title knowbase', content: 'content knowbase', stage: 1
#  end
#
#
#  context  'knowbase post view sign in user ' do
#
#    before do
#      sign_in @user
#    end
#  end
#end
