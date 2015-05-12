require 'spec_helper'

describe 'Plan::Post', type: :model do
  it_behaves_like 'base post', :plan, Plan::Post
end
