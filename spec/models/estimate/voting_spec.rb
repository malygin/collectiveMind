require 'spec_helper'

describe 'Estimate::Voting', type: :model do
  it 'default factory - valid' do
    expect(build(:estimate_voting)).to be_valid
  end

  context 'invalid without' do
    it 'user' do
      expect(build(:estimate_voting, user: nil)).to be_invalid
    end

    it 'post' do
      expect(build(:estimate_voting, estimate_post_id: nil)).to be_invalid
    end
  end
end