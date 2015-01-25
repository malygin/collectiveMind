require 'spec_helper'

describe 'Plan::Voting', type: :model do
  it 'default factory - valid' do
    expect(build(:plan_voting)).to be_valid
  end

  context 'invalid without' do
    it 'user' do
      expect(build(:plan_voting, user: nil)).to be_invalid
    end

    it 'post' do
      expect(build(:plan_voting, plan_post_id: nil)).to be_invalid
    end
  end
end