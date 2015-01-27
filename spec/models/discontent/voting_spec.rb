require 'spec_helper'

describe 'Discontent::Voting', type: :model do
  it 'default factory - valid' do
    expect(build(:discontent_voting)).to be_valid
  end

  context 'invalid without' do
    it 'user' do
      expect(build(:discontent_voting, user: nil)).to be_invalid
    end

    it 'post' do
      expect(build(:discontent_voting, discontent_post_id: nil)).to be_invalid
    end
  end
end