require 'spec_helper'

describe 'Plan::Post', type: :model do
  it 'default factory - valid' do
    expect(build(:plan)).to be_valid
  end

  context 'invalid without' do
    it 'project' do
      expect(build(:plan, project: nil)).to be_invalid
    end

    it 'user' do
      expect(build(:plan, user: nil)).to be_invalid
    end

    it 'status' do
      expect(build(:plan, status: nil)).to be_invalid
    end
  end
end
