require 'spec_helper'

describe 'Discontent::Post', type: :model do
  context 'invalid without' do
    it 'content' do
      expect(build(:discontent, content: '')).to be_invalid
    end
  end

  it_behaves_like 'base post', :discontent, Discontent::Post
end
