require 'spec_helper'

describe 'Novation::Post', type: :model do
  it_behaves_like 'base post', :novation, Novation::Post
end
