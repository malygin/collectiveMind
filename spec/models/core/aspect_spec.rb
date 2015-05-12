require 'spec_helper'

describe 'Core::Aspect::Post' do
  it 'default factory - valid' do
    expect(build(:aspect)).to be_valid
  end

  describe 'invalid without' do
    it 'project' do
      expect(build(:aspect, project: nil)).not_to be_valid
    end

    it 'user' do
      expect(build(:aspect, user: nil)).not_to be_valid
    end

    it 'content' do
      expect(build(:aspect, content: '')).not_to be_valid
    end
  end

  it_behaves_like 'correct status in post', :aspect
end
