require 'spec_helper'

describe 'Estimate::Post', type: :model do
  it 'default factory - valid' do
    expect(build(:estimate)).to be_valid
  end

  context 'invalid without' do
    it 'user' do
      expect(build(:estimate, user: nil)).to be_invalid
    end

    it 'status' do
      expect(build(:estimate, status: nil)).to be_invalid
    end

    it 'post' do
      expect(build(:estimate, post: nil)).to be_invalid
    end

    it 'project' do
      expect(build(:estimate, project: nil)).to be_invalid
    end
  end
end
