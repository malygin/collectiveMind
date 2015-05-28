require 'spec_helper'

describe 'Concept::Post', type: :model do
  context 'invalid without' do
    it 'title' do
      expect(build(:concept, title: nil)).to be_invalid
    end
  end

  it_behaves_like 'base post', :concept, Concept::Post
end
