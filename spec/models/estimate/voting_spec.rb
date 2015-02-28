require 'spec_helper'

describe 'Estimate::PostVoting', type: :model do
  it 'default factory - valid' do
    expect(build(:estimate_post_voting)).to be_valid
  end

  context 'invalid without' do
    it 'user' do
      expect(build(:estimate_post_voting, user: nil)).to be_invalid
    end

    it 'post' do
      expect(build(:estimate_post_voting, post_id: nil)).to be_invalid
    end
  end
end
