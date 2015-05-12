require 'spec_helper'

describe 'Core::Aspect::Post' do
  describe 'invalid without' do
    it 'content' do
      expect(build(:aspect, content: '')).not_to be_valid
    end
  end

  it_behaves_like 'base post', :aspect, Core::Aspect::Post
end
